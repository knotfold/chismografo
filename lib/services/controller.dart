import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trivia_form/services/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:io' show File, Platform;

class Controller with ChangeNotifier {
  UsuarioModel usuario = UsuarioModel(
    nombre: 'Memo',
    correo: 'Knotfold@gmail.com',
    documentId: 'Kixz42Qe8JXs87OKOJZ8',
    foto:
        'https://scontent-ssn1-1.xx.fbcdn.net/v/t1.0-9/90590478_3194401850588829_8179029891061121024_o.jpg?_nc_cat=111&_nc_sid=85a577&_nc_ohc=Ds1ApjyXdy8AX8gQWIP&_nc_ht=scontent-ssn1-1.xx&oh=5e2f518ff1449c1bc8f0f3894e32a39a&oe=5EBB0839',
  );
  
  notify() {
    notifyListeners();
  }

  String uid = '';
  String name = '';
  String email = '';
  String imageUrl = '';
  String activeToken;
  bool loading = false;
  String sexo;
  String tipo;
 



  signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await googleSignIn.signOut();
    await usuario.reference.updateData({
      'tokens': FieldValue.arrayRemove([activeToken])
    });
    await prefs.clear();
    uid = '';
    name = '';
    imageUrl = '';
    email = '';
    usuario.nombre = 'No name';
    notifyListeners();
    print('finished');
  }

  signIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('correo', usuario.correo);
    // await storeToken();
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
        usuario = UsuarioModel.fromDocumentSnapshot(onValue.documents.first);
      });
      // await storeToken();
      return true;
    }
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

  agregausuario(UsuarioModel usuario) {
    usuario = usuario;
  }
}
