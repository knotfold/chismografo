import 'dart:ffi';
import 'package:trivia_form/pages/pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trivia_form/shared/shared.dart';
import 'pages.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/services/services.dart';

class Home extends StatefulWidget {
  void pruena2() {}
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
        bottomNavigationBar: BottomNavigationBar(
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
                      .collection('formularios')
                      .where('invitaciones',
                          arrayContains: controller.usuario.usuario)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const Icon(Icons.collections_bookmark);
                    List<DocumentSnapshot> documents = snapshot.data.documents;

                    return documents.isEmpty
                        ? Icon(Icons.collections_bookmark)
                        : Stack(
                            children: <Widget>[
                              Container(
                                  child: Icon(
                                    Icons.collections_bookmark,
                                  ),
                                  width: 30,
                                  height: 30),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(right: 20),
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: yemahuevo),
                              )
                            ],
                          );
                  }),
              title: Text('Libretas Amigos'),
            ),
            BottomNavigationBarItem(
              icon: StreamBuilder(
                  stream: Firestore.instance
                      .collection('usuarios')
                      .where('solicitudesAE',
                          arrayContains: controller.usuario.documentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const Icon(Icons.group);

                    List<DocumentSnapshot> documents = snapshot.data.documents;

                    return documents.isEmpty
                        ? Icon(Icons.contacts)
                        : Stack(
                            children: <Widget>[
                              Container(
                                  child: Icon(
                                    Icons.contacts,
                                  ),
                                  width: 30,
                                  height: 30),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(right: 20),
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: yemahuevo),
                              )
                            ],
                          );
                  }),
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
        ),
      ),
    );
  }
}
