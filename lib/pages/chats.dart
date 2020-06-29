import 'package:ChisMe/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:ChisMe/services/services.dart';
import 'package:ChisMe/shared/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
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
      // floatingActionButton: FloatingActionButton(
      //     heroTag: 'btnAA1',
      //     child: Icon(
      //       Icons.search,
      //       size: 30,
      //       // color: Colors.black,
      //     ),
      //     onPressed: () {}),
      appBar: myAppBar(controller, context),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
             
              Text(
                'Chats',
                style: TextStyle(fontSize: 23),
              ),
              StreamBuilder(
                stream: Firestore.instance
                    .collection('usuarios')
                    .where('amigos',
                        arrayContains: controller.usuario.documentId)
                    .orderBy('nombre')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                        height: 50, child: const CircularProgressIndicator());
                  List<DocumentSnapshot> documents = snapshot.data.documents;
                  myFuture = buildChatList(documents, controller);

                  return FutureBuilder<List<UsuarioModel>>(
                      future: myFuture,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const CircularProgressIndicator();
                        List<UsuarioModel> chats = snapshot.data;
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            UsuarioModel usuario = chats[index];
                            return AmigoTile(
                              usuario: usuario,
                              miniProfile: false,
                            );
                          },
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
