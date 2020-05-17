import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ChisMe/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:ChisMe/shared/colors.dart';

//801510547545-ae7kl5f46tdf74uha67kicha4g7djk4u.apps.googleusercontent.com
class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String error = '';

  bool isLoading = true;
  bool isLoading2 = true;
  bool errorbase = false;

  Map<String, dynamic> loginMap = {'user': null, 'password': null};

  Future<bool> loginCheck(Controller controller) {
    controller.signInCheck().then((onValue) {
      isLoading2 = true;

      if (onValue) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        controller.loading = false;
        isLoading2 = false;
        setState(() {});
        return false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: WillPopScope(
        onWillPop: () async => false,
        child: FutureBuilder(
            future: loginCheck(controller),
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(40)),
                        child: Container(
                          //  decoration: BoxDecoration(
                          //    color: backgroundColor,
                          //   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight:Radius.circular(10))
                          //  ),
                          padding: const EdgeInsets.fromLTRB(0, 100, 0, 100),
                          color: primaryColor,
                          width: double.maxFinite,
                          child: Column(
                            children: <Widget>[
                              FirebaseMessage(),
                              Text(
                                'ChisMe',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 70, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'DESARROLLADO POR ',
                                    style: TextStyle(
                                        color: Colors.grey[50], fontSize: 15),
                                  ),
                                  Text(
                                    ' GUDTECH',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.all(4.0),
                        padding: const EdgeInsets.fromLTRB(0, 70, 0, 80),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            // SizedBox(
                            //   height: 70.0,
                            // ),

                            isLoading2 || controller.loading
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.black,
                                  )
                                : Column(
                                    children: <Widget>[
                                      Card(
                                        color: Colors.white,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 40),
                                        elevation: 9.0,
                                        shape: ContinuousRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0)),
                                        child: Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Column(
                                            children: <Widget>[
                                              // TextFormField(
                                              //   onSaved: (String texto) {
                                              //     loginMap['user'] = texto;
                                              //   },
                                              //   validator: (String texto) {
                                              //     if (texto.isEmpty ||
                                              //         texto == '' ||
                                              //         errorbase) {
                                              //       return 'Correo incorrecto';
                                              //     }
                                              //   },
                                              //   keyboardType: TextInputType.emailAddress,
                                              //   decoration: InputDecoration(
                                              //     contentPadding: EdgeInsets.fromLTRB(
                                              //         30.0, 15.0, 20.0, 15.0),
                                              //     labelText: 'Usuario',
                                              //     prefixIcon: Icon(Icons.account_circle),
                                              //     border: OutlineInputBorder(
                                              //       borderRadius: BorderRadius.circular(25.0),
                                              //     ),
                                              //   ),
                                              // ),
                                              // SizedBox(
                                              //   height: 10.0,
                                              // ),
                                              // TextFormField(
                                              //   obscureText: true,
                                              //   onSaved: (String texto) {
                                              //     loginMap['password'] = texto;
                                              //   },
                                              //   validator: (String texto) {
                                              //     if (texto.isEmpty ||
                                              //         texto == '' ||
                                              //         errorbase) {
                                              //       return 'Contraseña incorrecta';
                                              //     }
                                              //   },
                                              //   decoration: InputDecoration(
                                              //     contentPadding: EdgeInsets.fromLTRB(
                                              //         30.0, 15.0, 20.0, 15.0),
                                              //     labelText: 'Contraseña',
                                              //     prefixIcon: Icon(Icons.lock),
                                              //     border: OutlineInputBorder(
                                              //       borderRadius: BorderRadius.circular(25.0),
                                              //     ),
                                              //   ),
                                              // ),

                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  // OutlineButton(
                                                  //   onPressed: () async {
                                                  //     errorbase = false;

                                                  //     if (!key.currentState.validate()) {
                                                  //       return;
                                                  //     }

                                                  //     key.currentState.save();

                                                  //     setState(() {
                                                  //       isLoading2 = true;
                                                  //     });
                                                  //     var query = await Firestore.instance
                                                  //         .collection('usuarios')
                                                  //         .where('correo',
                                                  //             isEqualTo: loginMap['user'])
                                                  //         .where('contrasena',
                                                  //             isEqualTo: loginMap['password'])
                                                  //         .getDocuments();

                                                  //     if (query.documents.isEmpty) {
                                                  //       isLoading2 = false;

                                                  //       errorbase = true;
                                                  //       if (!key.currentState.validate()) {
                                                  //         return;
                                                  //       }
                                                  //     } else {
                                                  //       var user = query.documents.first;
                                                  //       controller.usuarioAct =
                                                  //           UsuarioModel.fromDocumentSnapshot(
                                                  //               user);
                                                  //       await controller.signIn();
                                                  //       print('accediste');
                                                  //       Navigator.of(context)
                                                  //           .pushNamedAndRemoveUntil(
                                                  //               '/',
                                                  //               ModalRoute.withName(
                                                  //                   '/home'));
                                                  //     }
                                                  //   },
                                                  //   shape: RoundedRectangleBorder(
                                                  //       borderRadius:
                                                  //           BorderRadius.circular(30)),
                                                  //   highlightElevation: 6,
                                                  //   borderSide:
                                                  //       BorderSide(color: Colors.black),
                                                  //   child: Padding(
                                                  //     padding: const EdgeInsets.fromLTRB(
                                                  //         0, 10, 0, 10),
                                                  //     child: FittedBox(
                                                  //       child: Row(
                                                  //         mainAxisSize: MainAxisSize.min,
                                                  //         mainAxisAlignment:
                                                  //             MainAxisAlignment.center,
                                                  //         children: <Widget>[
                                                  //           Icon(
                                                  //             Icons.account_box,
                                                  //             size: 20,
                                                  //           ),
                                                  //           Padding(
                                                  //             padding: const EdgeInsets.only(
                                                  //                 left: 15),
                                                  //             child: Text(
                                                  //               'Iniciar Sesión',
                                                  //               style: TextStyle(
                                                  //                 fontSize: 15,
                                                  //                 color: Colors.black,
                                                  //               ),
                                                  //             ),
                                                  //           )
                                                  //         ],
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  // SizedBox(
                                                  //   height: 10,
                                                  // ),
                                                  // OutlineButton(
                                                  //   onPressed: () => Navigator.of(context)
                                                  //       .pushReplacementNamed(
                                                  //           '/registro_usuario'),
                                                  //   shape: RoundedRectangleBorder(
                                                  //       borderRadius:
                                                  //           BorderRadius.circular(30)),
                                                  //   highlightElevation: 6,
                                                  //   borderSide:
                                                  //       BorderSide(color: Colors.black),
                                                  //   child: Padding(
                                                  //     padding: const EdgeInsets.fromLTRB(
                                                  //         0, 10, 0, 10),
                                                  //     child: FittedBox(
                                                  //       child: Row(
                                                  //         mainAxisSize: MainAxisSize.min,
                                                  //         mainAxisAlignment:
                                                  //             MainAxisAlignment.center,
                                                  //         children: <Widget>[
                                                  //           Icon(
                                                  //             Icons.group,
                                                  //             size: 20,
                                                  //           ),
                                                  //           Padding(
                                                  //             padding: const EdgeInsets.only(
                                                  //                 left: 15),
                                                  //             child: Text(
                                                  //               'Registrate',
                                                  //               style: TextStyle(
                                                  //                 fontSize: 15,
                                                  //                 color: Colors.black,
                                                  //               ),
                                                  //             ),
                                                  //           )
                                                  //         ],
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  // Divider(),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  _singInButton(controller),
                                                  Divider(),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  _singInButtonFacebook(
                                                      controller),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _singInButton(Controller controller) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        print('entro al on pressed');
        signInWithGoogle(controller).then((value) async {
          controller.loading = true;
          controller.notify();
          if (controller.email == null || controller.email.trim() == '') {
            controller.loading = false;
            controller.notify();
            print('wtff');
            return;
          }

          // showDialog(context: context,
          // child: AlertDialog(
          //   backgroundColor: Colors.white,
          //   title: Text('Cuenta bloqueada', style: TextStyle(color: Colors.black),),
          //   content: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: <Widget>[
          //        Text('Esta cuenta esta bloqueada por inflingir las normas de la comunidad, para mas información comunicarse al correo: chismesoporte@gmail.com',  style: TextStyle(color: Colors.black),),
          //        Icon(Icons.report, color:Colors.red, size: 100)
          //     ],
          //   ),
          // ));
          // await googleSignIn.signOut();
          // return;

          print('estoy dentro y voy a navegar con ' + controller.name);
          Firestore.instance
              .collection('usuarios')
              .where('correo', isEqualTo: controller.email)
              .getDocuments()
              .then((onValue) async {
            if (onValue.documents.isEmpty) {
              controller.loading = false;

              Navigator.of(context).pushReplacementNamed('/registro_usuario');
            } else {
              bool banned = onValue.documents.first['banned'] ?? false;
              if (banned) {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text(
                        'Cuenta bloqueada',
                        style: TextStyle(color: Colors.black),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Esta cuenta esta bloqueada por inflingir las normas de la comunidad, para mas información comunicarse al correo: chismesoporte@gmail.com',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(Icons.report, color: Colors.red, size: 100)
                        ],
                      ),
                    ));
                await googleSignIn.signOut();
                return;
              }
              controller.usuarioAct =
                  UsuarioModel.fromDocumentSnapshot(onValue.documents.first);
              await controller.signIn();
              controller.loading = false;
              Navigator.of(context).pushReplacementNamed('/home');
            }
          });
        }).catchError((onError) {
          print(onError);
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      highlightElevation: 6,
      borderSide: BorderSide(color: Colors.black),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('assets/google-logo.png'),
                height: 35,
                width: 35,
              ),
              // Icon(
              //   FontAwesomeIcons.google,
              //   size: 30,
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Acceder con Google ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _singInButtonFacebook(Controller controller) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        login(controller).then((value) async {
          if (controller.uid == null || controller.uid.trim() == '') {
            controller.loading = false;
            controller.notify();
            print('wtff');
            return;
          }
         

      
        

          print('estoy dentro y voy a navegar con ' + controller.name);

          Firestore.instance
              .collection('usuarios')
              .where('uid', isEqualTo: controller.uid.trim())
              .getDocuments()
              .then((onValue) async {
            if (onValue.documents.isEmpty) {
              controller.loading = false;
              Navigator.of(context).pushReplacementNamed('/registro_usuario');
            } else {
              bool banned = onValue.documents.first['banned'] ?? false;
              if (banned) {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text(
                        'Cuenta bloqueada',
                        style: TextStyle(color: Colors.black),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Esta cuenta esta bloqueada por inflingir las normas de la comunidad, para mas información comunicarse al correo: chismesoporte@gmail.com',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(Icons.report, color: Colors.red, size: 100)
                        ],
                      ),
                    ));
                await facebookSignIn.logOut();
                return;
              }
              controller.usuarioAct =
                  UsuarioModel.fromDocumentSnapshot(onValue.documents.first);
              await controller.signIn();
              controller.loading = false;
              Navigator.of(context).pushReplacementNamed('/home');
            }
          });
        }).catchError((onError) {
          print(onError);
        });
        // print('entro al on pressed');
        // signInWithGoogle(controller).then((value) async {
        //   print('estoy dentro y voy a navegar con' + controller.name);
        //   Firestore.instance
        //       .collection('usuarios')
        //       .where('correo', isEqualTo: controller.email)
        //       .getDocuments()
        //       .then((onValue) async {
        //     if (onValue.documents.isEmpty) {
        //       Navigator.of(context).pushReplacementNamed('/registro_usuario');
        //     } else {
        //       controller.usuarioAct =
        //           UsuarioModel.fromDocumentSnapshot(onValue.documents.first);
        //       await controller.signIn();
        //       Navigator.of(context).pushReplacementNamed('/home');
        //     }
        //   });
        // }).catchError((onError) {
        //   print(onError);
        // });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      highlightElevation: 6,
      borderSide: BorderSide(color: Colors.black),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.facebook,
                size: 30,
                color: Colors.blue,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Acceder con Facebook',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
