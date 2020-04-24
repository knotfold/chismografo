import 'package:flutter/material.dart';
import 'package:trivia_form/shared/shared.dart';
import 'pages.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _widgetOptions = <Widget>[
    TusLibretas(),
    LibretasA(),
    Amigos(),
    Perfil(),
    Store(),
  ];

  @override
  void initState() {
    super.initState();
    FirebaseMessage firebaseMessage = FirebaseMessage();
  }

  _onItemTapped(int index, Controller controller) {
    setState(() {
      controller.seleccionado = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: _widgetOptions.elementAt(controller.seleccionado),
        bottomNavigationBar: StreamBuilder(
            stream: controller.usuario.reference.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UsuarioModel newU =
                    UsuarioModel.fromDocumentSnapshot(snapshot.data);
              }
              return BottomNavigationBar(
                currentIndex: controller.seleccionado,
                backgroundColor: Colors.black,
                fixedColor: Colors.black,
                unselectedItemColor: Colors.blueGrey,
                onTap: (int index) {
                  _onItemTapped(index, controller);
                },
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book),
                    title: Text('Tus Libretas'),
                  ),
                  BottomNavigationBarItem(
                    icon: StreamBuilder(
                        stream: Firestore.instance
                            .collection('usuarios')
                            .where('solicitudesAE',
                                arrayContains: controller.usuario.documentId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<DocumentSnapshot> documents =
                              snapshot.data.documents;

                          return Icon(Icons.collections_bookmark);
                        }),
                    title: Text('Libretas Amigos'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.group),
                    title: Text('Amigos'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    title: Text('Perfil'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.store),
                    title: Text('Tienda'),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
