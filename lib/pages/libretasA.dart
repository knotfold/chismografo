import 'package:flutter/material.dart';
import 'package:trivia_form/shared/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trivia_form/services/services.dart';
import 'package:provider/provider.dart';

class LibretasA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of(context);
    return Scaffold(
      floatingActionButton: StreamBuilder(
        stream: Firestore.instance
            .collection('formularios')
            .where('invitaciones', arrayContains: controller.usuario.documentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          List<DocumentSnapshot> documents = snapshot.data.documents;
          return FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                child: Dialog(
                  child: Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        FormularioModel formularioModel =
                            FormularioModel.fromDS(documents[index]);
                        return ListTile(
                          leading: Icon(Icons.book),
                          title: Text(formularioModel.nombre),
                          subtitle: Text(formularioModel.creadorUsuario),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                onPressed: () async {
                                  controller.toFillForm = formularioModel;
                                  Navigator.of(context).pushNamed(
                                      '/responderLibreta',
                                      arguments: formularioModel);
                                },
                                icon: Icon(Icons.check),
                              ),
                              IconButton(
                                onPressed: () async {},
                                icon: Icon(Icons.cancel),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
            label:
                Text(documents.isEmpty ? 'Sin solicitudes' : 'Nueva solicitud'),
            icon: Icon(documents.isEmpty ? Icons.tag_faces : Icons.fiber_new),
          );
        },
      ),
      appBar: myAppBar(),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Libretas Amigos',
              style: TextStyle(fontSize: 25),
            ),
            Container(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('formularios')
                    .where('usuarios',
                        arrayContains: controller.usuario.usuario)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const CircularProgressIndicator();
                  List<DocumentSnapshot> documents = snapshot.data.documents;
                  return ListView.builder(
                      itemCount: documents.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        FormularioModel formularioModel = FormularioModel.fromDS(documents[index]);
                        return ListTile(
                          onTap: () {
                            controller.toFillForm = formularioModel;
                            Navigator.of(context).pushNamed('/libretaDetalles');
                          },
                          title: Text(formularioModel.nombre),
                          subtitle: Text(formularioModel.creadorUsuario),
                          trailing: Text('${formularioModel.usuarios.length} / 25'),
                          
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
