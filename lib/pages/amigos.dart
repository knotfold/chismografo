import 'dart:developer';

import 'package:ChisMe/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:ChisMe/services/services.dart';
import 'package:ChisMe/shared/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Amigos extends StatefulWidget {
  @override
  _AmigosState createState() => _AmigosState();
}

class _AmigosState extends State<Amigos> {
  Future myFuture;
  @override
  void initState() {
    super.initState();
  }

  Future<List<UsuarioModel>> buildChatList(
      List<DocumentSnapshot> list, Controller controller) async {
    List<UsuarioModel> chats = [];

    for (var element in list) {
      bool hasChat = element[controller.usuarioAct.usuario + 'Chat'] ?? false;
      if (hasChat)
        chats.add(
          UsuarioModel.fromDocumentSnapshot(
              element, controller.usuario.usuario),
        );
    }
    chats.sort((a, b) => b.userLastMsg.compareTo(a.userLastMsg));
    return chats;
  }

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'btnAA1',
        child: controller.solicitudesAEDocuments.isEmpty
            ? Icon(
                Icons.search,
                size: 30,
                color: pDark,
              )
            : Stack(
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.add_alert,
                      size: 30,
                      color: pDark,
                    ),
                    width: 30,
                    height: 30,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: yemahuevo),
                  )
                ],
              ),
        onPressed: () {
          showDialog(
            context: context,
            child: SolicitudesAmistad(
              documents: controller.solicitudesAEDocuments,
            ),
          );
        },
      ),
      appBar: myAppBar(controller, context),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Amigos',
                style: TextStyle(fontSize: 23),
              ),
              // AmigosHorizontalList(
              //     usuario: controller.usuario, controller: controller),
              // SizedBox(
              //   height: 20,
              // ),
              // Text(
              //   'Chats',
              //   style: TextStyle(fontSize: 23),
              // ),
              StreamBuilder(
                stream: Firestore.instance
                    .collection('usuarios')
                    .where('amigos', arrayContains: controller.usuario.usuario)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                        height: 50, child: const CircularProgressIndicator());
                  List<DocumentSnapshot> documents = snapshot.data.documents;
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      UsuarioModel usuario = UsuarioModel.fromDocumentSnapshot(
                          documents[index], controller.usuarioAct.usuario);
                      return AmigoTile(
                        usuario: usuario,
                        miniProfile: true,
                      );
                    },
                  );

                  // return FutureBuilder<List<UsuarioModel>>(
                  //     future: myFuture,
                  //     builder: (context, snapshot) {
                  //       if (!snapshot.hasData)
                  //         return const CircularProgressIndicator();
                  //       List<UsuarioModel> chats = snapshot.data;
                  //       return ListView.builder(
                  //         physics: NeverScrollableScrollPhysics(),
                  //         shrinkWrap: true,
                  //         itemCount: chats.length,
                  //         itemBuilder: (context, index) {
                  //           UsuarioModel usuario = chats[index];
                  //           return AmigoTile(
                  //             usuario: usuario,
                  //             miniProfile: false,
                  //           );
                  //         },
                  //       );
                  //     });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SolicitudesAmistad extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  SolicitudesAmistad({this.documents});
  @override
  _SolicitudesAmistadState createState() => _SolicitudesAmistadState();
}

class _SolicitudesAmistadState extends State<SolicitudesAmistad> {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return WillPopScope(
      onWillPop: () async {
        return !controller.loading;
      },
      child: Dialog(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Solicitudes de Amistad',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              widget.documents.isEmpty
                  ? Text(
                      'No tienes solicitudes',
                      style: TextStyle(color: Colors.white),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.documents.length,
                      itemBuilder: (context, index) {
                        UsuarioModel usuario =
                            UsuarioModel.fromDocumentSnapshot(
                                widget.documents[index],
                                controller.usuarioAct.usuario);
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(usuario.foto),
                          ),
                          title: Text(usuario.nombre,
                              style: TextStyle(color: Colors.white)),
                          trailing: controller.loading
                              ? CircularProgressIndicator()
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () async {
                                        controller.loading = true;
                                        controller.notify();
                                        await controller.usuario.reference
                                            .updateData({
                                          'amigos': FieldValue.arrayUnion(
                                              [usuario.documentId])
                                        });
                                        await usuario.reference.updateData({
                                          'solicitudesAE':
                                              FieldValue.arrayRemove([
                                            controller.usuario.documentId
                                          ]),
                                          'amigos': FieldValue.arrayUnion(
                                              [controller.usuario.documentId])
                                        });
                                        controller.usuario.amigos
                                            .add(usuario.documentId);
                                        controller.usuario.solicitudesAE
                                            .remove(usuario.documentId);
                                        controller.loading = false;
                                        controller.notify();
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        controller.loading = true;
                                        controller.notify();
                                        await usuario.reference.updateData({
                                          'solicitudesAE':
                                              FieldValue.arrayRemove([
                                            controller.usuario.documentId
                                          ])
                                        });
                                        controller.loading = false;
                                        controller.notify();
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(
                                        Icons.delete_forever,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                        );
                      },
                    ),
              SizedBox(
                height: 20,
              ),
              FloatingActionButton.extended(
                heroTag: 'btnA1',
                elevation: 0,
                shape: BeveledRectangleBorder(),
                onPressed: () => showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                ),
                icon: Icon(
                  Icons.search,
                  size: 17,
                ),
                label: Text('Buscar Amigos'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
