import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:ChisMe/services/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistroUsuario extends StatefulWidget {
  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final TextEditingController textEditingControllerFecha =
      TextEditingController();
  DateTime date = DateTime.now();
  File imagen;
  bool isLoadig = false;
  final _usuarioform = GlobalKey<FormState>();
  bool tos = false;
  String tipotemp = '';
  bool correov = true;
  bool usuariov = true;
  Map<String, dynamic> formUsuario = {
    'nombre': null,
    'usuario': null,
    'correo': null,
    'foto': null,
    'usuarioSearch': null,
    'monedasFree':false,
    'dailyAnswers' : 3,
    'dailyFormularios': 3,
    'uid' : null,
  };

  // _launchURL() async {
  //   const url =
  //       'https://firebasestorage.googleapis.com/v0/b/adoptionapp-8a76d.appspot.com/o/Pol%C3%ADticas%20de%20privacidad.pdf?alt=media&token=ff41a4f7-c898-4426-95e6-fa5bd7d45099';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);

    return WillPopScope(
      onWillPop: () async {
        // signOutGoogle();
        Navigator.of(context).pop();
        return true;
      },
      child: WillPopScope(
        onWillPop: () async {
          return isLoadig ? false : true;
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Form(
                key: _usuarioform,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    Center(
                      child: Text(
                        'Ingresa tus datos:',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Los campos marcados con * son obligatorios.',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text('* Foto: '),
                    GestureDetector(
                      onTap: () async {
                        imagen = await controller.getImage(context);
                        setState(() {});
                      },
                      child: Center(
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                  width: 150.0,
                                  height: 150.0,
                                  child: CircleAvatar(
                                    radius: 45.0,
                                    backgroundImage: controller
                                                .imageUrl.isEmpty &&
                                            imagen == null
                                        ? AssetImage('assets/dog.png')
                                        : controller.imageUrl.isNotEmpty &&
                                                imagen == null
                                            ? NetworkImage(controller.imageUrl)
                                            : FileImage(imagen),
                                    backgroundColor: Colors.transparent,
                                  )),
                              CircleAvatar(
                                child: IconButton(
                                    icon: Icon(Icons.photo_camera),
                                    onPressed: () async {
                                      imagen =
                                          await controller.getImage(context);
                                      setState(() {});
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                   
                      initialValue:
                          controller.name.isEmpty ? null : controller.name,
                      onSaved: (String value) {
                        formUsuario['nombre'] = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Nombre vacío';
                        }
                        if (value.length < 5) {
                          return 'Se requiere al menos un apellido';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: '* Nombre completo',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                   controller.email.isEmpty ? Container() : TextFormField(
                      enabled: false,
                      initialValue:
                          controller.email.isEmpty ? null : controller.email,
                      onSaved: (String value) {
                        formUsuario['correo'] = value.trim();
                      },
                      validator: (String value) {
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                     
                        return null;
                      },
                      maxLines: 1,
                      minLines: 1,
                      decoration: InputDecoration(
                          labelText: '*Correo electrónico ',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      maxLength: 10,
                      maxLines: 1,
                      minLines: 1,
                      onSaved: (String value) {
                        formUsuario['usuario'] = '@' + value.trim();
                        formUsuario['usuarioSearch'] =
                            '@' + value.toLowerCase().trim();
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Usuario vacío';
                        } else if (usuariov == false) {
                          return 'Usuario existente';
                        } else if (value.contains('@')) {
                          return 'Tu nombre de usuario no debe llevar "@"';
                        }
                        else if (value.contains(' ')) {
                          return 'Tu nombre de usuario no debe llevar espacios';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: '* Usuario',
                          border: OutlineInputBorder(
                            
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        Switch(
                          value: tos,
                          onChanged: ((value) {
                            setState(() {
                              tos = value;
                            });
                          }),
                        ),
                        GestureDetector(
                            onTap: () => _launchURL(),
                            child: Text(
                              'Aceptar terminos y condiciones',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    tos
                        ? Text('')
                        : Text(
                            '* Es necesario aceptar nuestros terminos y condiciones para concluir el registro *',
                            style: TextStyle(
                                color: Colors.red,
                                textBaseline: TextBaseline.alphabetic,
                                fontWeight: FontWeight.bold),
                          ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        saveButton(controller),
                        FlatButton(
                          child: Container(
                            child: ListTile(
                              title: Text(
                                'Cancelar Registro',
                                style: TextStyle(color: Colors.black),
                              ),
                              leading: Icon(Icons.cancel),
                            ),
                            width: double.maxFinite,
                          ),
                          onPressed: () {
                            signOutGoogle();
                            Navigator.of(context).pushReplacementNamed('/');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget saveButton(Controller controller) {
    return isLoadig
        ? CircularProgressIndicator()
        : RaisedButton.icon(
            icon: Icon(Icons.check),
            label: Text('Guardar'),
            onPressed: () async {
              correov = true;
              usuariov = true;
              if (!_usuarioform.currentState.validate()) {
                setState(() {
                  isLoadig = false;
                });
                return;
              }

              _usuarioform.currentState.save();

              await _validatorUser(formUsuario['usuarioSearch']);
              await _validatorEmail(formUsuario['correo']);

              formUsuario['uid'] = controller.uid;

              setState(() {
                isLoadig = true;
              });
              if (!_usuarioform.currentState.validate()) {
                setState(() {
                  isLoadig = false;
                });
                return;
              }

              if (controller.imageUrl == null) {
                setState(() {
                  isLoadig = false;
                });
                return null;
              }

              if (!tos) {
                setState(() {
                  isLoadig = false;
                });
                return;
              }
              _usuarioform.currentState.save();
              setState(() {
                isLoadig = true;
              });

              if (imagen != null) {
                final String fileName = formUsuario['usuario'] +
                    '/perfil/PP' +
                    DateTime.now().toString();

                StorageReference storageRef =
                    FirebaseStorage.instance.ref().child(fileName);

                final StorageUploadTask uploadTask = storageRef.putFile(
                  imagen,
                );

                final StorageTaskSnapshot downloadUrl =
                    (await uploadTask.onComplete);

                final String url = (await downloadUrl.ref.getDownloadURL());
                print('URL Is $url');

                formUsuario['foto'] = url;
                formUsuario['fotoStorageRef'] = downloadUrl.ref.path;
              } else {
                formUsuario['foto'] = controller.imageUrl;
              }

              await Firestore.instance
                  .collection('usuarios')
                  .document(formUsuario['usuario'])
                  .setData(formUsuario);

              var ds = await Firestore.instance
                  .collection('usuarios')
                  .document(formUsuario['usuario'])
                  .get();

              controller.agregausuario(UsuarioModel.fromDocumentSnapshot(ds, 'meh'));
              controller.signIn();
              Navigator.of(context).pushReplacementNamed('/home');
            });
  }

  _launchURL() async {
    const url =
        'http://gudtech.tech/es/chsm-tos/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future _validatorEmail(String value) async {
    print(value);
    await Firestore.instance
        .collection('usuarios')
        .where('correo', isEqualTo: value)
        .getDocuments()
        .then((onValue) {
      if (onValue.documents.isNotEmpty) {
        print('correo existente');
        setState(() {
          correov = false;
        });
      } else {
        setState(() {
          correov = true;
        });
      }
    });
  }

  Future _validatorUser(String value) async {
    print(value);
    await Firestore.instance
        .collection('usuarios')
        .where('usuarioSearch', isEqualTo: value)
        .getDocuments()
        .then((onValue) {
      if (onValue.documents.isNotEmpty) {
        print('usuario existente');
        setState(() {
          usuariov = false;
        });
      } else {
        setState(() {
          usuariov = true;
        });
      }
    });
  }
}
