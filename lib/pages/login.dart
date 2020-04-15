import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:trivia_form/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);

    controller.signInCheck().then((onValue) {
      isLoading2 = true;

      if (onValue) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        if (mounted) {
          setState(() {
            isLoading2 = false;
          });
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: WillPopScope(
        onWillPop: () async => false,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.all(4.0),
              padding: const EdgeInsets.fromLTRB(0, 70, 0, 90),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'TRIVIA',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'DESARROLLADO POR',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      Text(
                        ' GUDTECH',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  FlatButton(
                      onPressed: () {
                        return Navigator.of(context)
                            .pushReplacementNamed('/home');
                      },
                      child: null),
                  isLoading2
                      ? CircularProgressIndicator(backgroundColor: Colors.black,)
                      : Column(
                          children: <Widget>[
                            Card(
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              elevation: 9.0,
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 30.0,
                                    ),
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
                                    SizedBox(
                                      height: 25.0,
                                    ),
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
                                        Divider(),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _singInButton(controller),
                                        Divider(),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _singInButtonFacebook(controller),
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
          ),
        ),
      ),
    );
  }

  Widget _singInButton(Controller controller) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        print('entro al on pressed');
        signInWithGoogle(controller).then((value) async {
          print('estoy dentro y voy a navegar con ' + controller.name);
          Firestore.instance
              .collection('usuarios')
              .where('correo', isEqualTo: controller.email)
              .getDocuments()
              .then((onValue) async {
            if (onValue.documents.isEmpty) {
              Navigator.of(context).pushReplacementNamed('/registro_usuario');
            } else {
              controller.usuarioAct =
                  UsuarioModel.fromDocumentSnapshot(onValue.documents.first);
              await controller.signIn();
              Navigator.of(context).pushReplacementNamed('/home');
            }
          });
        }).catchError((onError) {
          print(onError);
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                FontAwesomeIcons.google,
                size: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Acceder con Google',
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

Widget _singInButtonFacebook(Controller controller) {
  return OutlineButton(
    splashColor: Colors.grey,
    onPressed: () async {
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
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
              size: 15,
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
