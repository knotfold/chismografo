import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trivia_form/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'dart:io' show File, Platform;

class Controller with ChangeNotifier {
  // UsuarioModel usuarioAct = UsuarioModel(
  //   nombre: 'Memo',
  //   correo: 'Knotfold@gmail.com',
  //   foto:
  //       'https://scontent-ssn1-1.xx.fbcdn.net/v/t1.0-9/90590478_3194401850588829_8179029891061121024_o.jpg?_nc_cat=111&_nc_sid=85a577&_nc_ohc=Ds1ApjyXdy8AX8gQWIP&_nc_ht=scontent-ssn1-1.xx&oh=5e2f518ff1449c1bc8f0f3894e32a39a&oe=5EBB0839',
  // );
  UsuarioModel usuarioAct;
  int seleccionado = 0;
  UsuarioModel get usuario => usuarioAct;
  agregausuario(UsuarioModel usuario) {
    usuarioAct = usuario;
  }

  notify() {
    notifyListeners();
  }

  //generales
  String uid = '';
  String name = '';
  String email = '';
  String imageUrl = '';
  String activeToken;
  bool loading = false;
  String sexo;
  String tipo;

  //cosas para responder un formulario
  FormularioModel toFillForm;
  List<String> respuestas = [];
  List<Respuesta> vRespuestas = [];
  TextEditingController textECR = TextEditingController();

    PageController pageController2 = PageController();
    int sdtP;


  //finnnn

  Future<bool> gastarMonedas() async {
    bool status = true;
    loading = true;
    notifyListeners();
    if (usuarioAct.coins < 5) {
      loading = false;
      return false;
    }
    var newCoins = usuarioAct.coins - 5;

    await usuarioAct.reference
        .updateData({'coins': newCoins}).catchError((onError) {
      print('error');
      status = false;
      return false;
    });

    if (!status) {
      return false;
    }

    usuarioAct.coins = usuarioAct.coins - 5;
    loading = false;

    notifyListeners();

    return true;
  }

  Future<bool> buyCoins(int amount) async {
    if (await checkPayment()) {
      print(true);
      usuarioAct.coins = usuarioAct.coins + amount;
      await usuarioAct.reference.updateData({
        'coins': usuarioAct.coins,
      });
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> checkPayment() async {
    bool status = true;

    print('purchased');
    return status;
  }

  //Cosas para llenar  una libreta
  List<String> preguntas = [];
  List<String> participantes = [];
  bool privado = true;
  String nombreLibreta;

  PageController pageController = PageController();
  TextEditingController textEditingController = TextEditingController();

  File image;

  crearFormulario(BuildContext context) async {
    List<Pregunta> preguntasM = [];
    loading = true;
    notify();
    print('first');
    if (preguntas.length < 3) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Muy Pocas Preguntas'),
          content: Text('Tu libreta debe de tener al menos 3 Preguntas'),
        ),
      );
      return false;
    }
    preguntas.forEach((pregunta) {
      preguntasM.add(Pregunta.fromString(pregunta));
    });

    String url;
    
    if(image != null){
 final String fileName =
        usuarioAct.correo + '/libretas/' + DateTime.now().toString();

    StorageReference storageRef =
        FirebaseStorage.instance.ref().child(fileName);

    final StorageUploadTask uploadTask = storageRef.putFile(
      image,
    );

    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);

    url = (await downloadUrl.ref.getDownloadURL());
    print('URL Is $url');
    }else{
      url = '';
    }
   

    print('second');
    print(preguntasM.length);
    FormularioModel formularioModel = FormularioModel(
        creadorID: usuario.documentId,
        invitaciones: participantes,
        preguntas: preguntasM,
        priv: privado,
        nombre: textEditingController.text,
        creadorUsuario: usuario.usuario,
        creadorfoto: usuario.foto,

        imagen: url);


    print('third');
    await Firestore.instance
        .collection('formularios')
        .add(formularioModel.toMap())
        .catchError((onError) {
      print(onError);
      return false;
    });

    loading = false;
    preguntas.clear();
    participantes.clear();
    privado = true;
    nombreLibreta = '';
    textEditingController.clear();
    image = null;
    return true;
  }

  //fiiiiiiin

  String dateString(DateTime dateTime) {
    return dateTime.day.toString() +
        '-' +
        dateTime.month.toString() +
        '-' +
        dateTime.year.toString();
  }

  signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await googleSignIn.signOut();
    await facebookSignIn.logOut();
    
    await usuario.reference.updateData({
      'tokens': FieldValue.arrayRemove([activeToken])
    });
    await prefs.clear();
    uid = '';
    name = '';
    imageUrl = '';
    email = '';
    usuario.nombre = 'No name';
    print('finished');
  }

  signIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('correo', usuario.correo);
    await storeToken();
  }

  Future<bool> signInCheck() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('correo') == null) {
      return false;
    } else {
      await Firestore.instance
          .collection('usuarios')
          .where('correo', isEqualTo: prefs.getString('correo'))
          .getDocuments()
          .then((onValue) {
        usuarioAct = UsuarioModel.fromDocumentSnapshot(onValue.documents.first);
      });
      await storeToken();
      return true;
    }
  }

  storeToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.getToken().then((value) {
      activeToken = value;
      usuario.reference.updateData({
        'tokens': FieldValue.arrayUnion([value])
      });
    });
  }

  permissonDeniedDialog(BuildContext context) {
    return showDialog(
      context: context,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '¡La aplicación no puede acceder a tus fotos y a tu camara por que no le has asignado los permisos, ve a la configuración de tu celular y asignale los permisos!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton.extended(
                onPressed: () async => await openAppSettings(),
                label: Text('Configuración'),
                icon: Icon(Icons.settings),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getImageCamera(BuildContext context) async {
    var permisson = await checkGalerryPermisson(true);
    if (permisson) {
      var image = await ImagePicker.pickImage(
              source: ImageSource.camera, maxHeight: 750, maxWidth: 750)
          .catchError((onError) => permissonDeniedDialog(context));

      return image;
    } else {
      return permissonDeniedDialog(context);
    }
  }

  Future getImage(BuildContext context) async {
    var permisson = await checkGalerryPermisson(false);
    if (permisson) {
      var image = await ImagePicker.pickImage(
              source: ImageSource.gallery, maxHeight: 750, maxWidth: 750)
          .catchError((onError) => permissonDeniedDialog(context));

      return image;
    } else {
      return permissonDeniedDialog(context);
    }
  }

  Future<bool> checkGalerryPermisson(bool camera) async {
    if (Platform.isIOS) {
      PermissionStatus permission = camera
          ? await Permission.camera.status
          : await Permission.photos.status;
      if (permission != PermissionStatus.granted) {
        if (camera
            ? await Permission.camera.request().isGranted
            : await Permission.photos.request().isGranted) {
          return true;
        } else {
          return false;
        }
      }
    } else {
      var idk = camera
          ? await Permission.camera.status
          : await Permission.storage.status;
      print('Permisos stauts!!! ' + idk.toString());
      if (idk == PermissionStatus.permanentlyDenied) {
        return false;
      } else {
        return true;
      }
    }
    return true;
  }
}
