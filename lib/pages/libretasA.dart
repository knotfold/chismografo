import 'package:flutter/material.dart';
import 'package:trivia_form/pages/pages.dart';

import 'package:trivia_form/shared/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trivia_form/services/services.dart';
import 'package:provider/provider.dart';

class LibretasA extends StatelessWidget {
  final Home home;
  LibretasA({this.home});
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: StreamBuilder(
        stream: Firestore.instance
            .collection('formularios')
            .where('invitaciones', arrayContains: controller.usuario.usuario)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          List<DocumentSnapshot> documents = snapshot.data.documents;
          return FloatingActionButton.extended(
            heroTag: 'btnA1',
            onPressed: () {
              documents.isEmpty
                  ? null
                  : showDialog(
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
                                      onPressed: () async {
                                        formularioModel.reference.updateData({
                                          'invitaciones':
                                              FieldValue.arrayRemove(
                                                  [controller.usuario.usuario])
                                        });
                                        Navigator.of(context).pop();
                                      },
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
            icon: documents.isEmpty
                ? Icon(
                    Icons.tag_faces,
                    size: 30,
                  )
                : Stack(
                    children: <Widget>[
                      Container(
                          child: Icon(
                            Icons.fiber_new,
                            size: 30,
                          ),
                          width: 30,
                          height: 30),
                      Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(left: 20),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: yemahuevo),
                      )
                    ],
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
                'Libretas Amigos',
                style: TextStyle(fontSize: 22),
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
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: documents.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          FormularioModel formularioModel =
                              FormularioModel.fromDS(documents[index]);
                          return ListTile(
                            onTap: () {
                              controller.toFillForm = formularioModel;
                              Navigator.of(context)
                                  .pushNamed('/libretaDetalles');
                            },
                            title: Text(
                              formularioModel.nombre,
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: Text(formularioModel.creadorUsuario),
                            trailing:
                                Text('${formularioModel.usuarios.length} / 25'),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
