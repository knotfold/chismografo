import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat extends StatelessWidget {
  final List<String> usuarios;
  final String nombre;
  final String foto;
  Chat({this.usuarios, this.nombre, this.foto});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(nombre),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(foto),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: FutureBuilder<DocumentReference>(
                    future: getChat(usuarios),
                    builder: (context, snapshot) {
                      return StreamBuilder(
                        stream: snapshot.data.snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return const CircularProgressIndicator();
                          List<DocumentSnapshot> documents =
                              snapshot.data.documents;
                          return ListView.builder(
                              itemCount: documents.length,
                              itemBuilder: (context, index) {});
                        },
                      );
                    }),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                TextField(),
                Icon(Icons.send)

              ],
            )
          ],
        ),
      ),
    );
  }

  Future<DocumentReference> getChat(List<String> usuarios) async {
    var query = await Firestore.instance
        .collection('chats')
        .where('usuarios', arrayContains: usuarios)
        .getDocuments();
    if (query.documents.isEmpty) {
      var add = await Firestore.instance
          .collection('chats')
          .add({'usuarios': usuarios});
          return add;
    } else {
      return query.documents.first.reference;
    }
  }
}
