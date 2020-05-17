import 'package:flutter/material.dart';
import 'package:ChisMe/pages/pages.dart';
import 'package:ChisMe/shared/libretaCard.dart';

import 'package:ChisMe/shared/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ChisMe/services/services.dart';
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
                          child: documents.isEmpty ? Text('No tienes solicitudes') : ListView.builder(
                            shrinkWrap: true,
                            itemCount: documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              FormularioModel formularioModel =
                                  FormularioModel.fromDS(documents[index]);
                              return ListTile(
                                leading: Icon(
                                  Icons.book,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  formularioModel.nombre,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  formularioModel.creadorUsuario,
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: controller.loading
                                    ? CircularProgressIndicator
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          IconButton(
                                            onPressed: () async {
                                              controller.toFillForm =
                                                  formularioModel;
                                              Navigator.of(context).pushNamed(
                                                  '/responderLibreta',
                                                  arguments: formularioModel);
                                            },
                                            icon: Icon(Icons.check, color: Colors.white54),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              controller.loading = true;
                                              controller.notify();
                                            documents[index].reference
                                                  .updateData({
                                                'invitaciones':
                                                    FieldValue.arrayRemove([
                                                  controller.usuario.usuario
                                                ])
                                              });
                                              controller.loading = false;
                                              controller.notify();
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(Icons.cancel, color: Colors.white54),
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
              SizedBox(
                height: 10,
              ),
              Text(
                'Libretas Amigos',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                height: 20,
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
                    return documents.isEmpty
                        ? Text(
                            'No estas participando en ninguna libreta de amigos :(')
                        : ListView.builder(
                            //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            // crossAxisCount:1,crossAxisSpacing: 10,childAspectRatio: 2.5,mainAxisSpacing: 5,),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: documents.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              FormularioModel formularioModel =
                                  FormularioModel.fromDS(documents[index]);
                              return LibretaCard(
                                  formularioModel: formularioModel,
                                  controller: controller);
                              //     GestureDetector(
                              //   onTap: () {
                              //     controller.toFillForm = formularioModel;
                              //     Navigator.of(context)
                              //         .pushNamed('/libretaDetalles');
                              //   },
                              //   child: Container(

                              //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),gradient: LinearGradient(colors: ([colorg1,colorg2]),begin: Alignment.topRight,end: Alignment.topLeft)),
                              //     child: Column(

                              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: <Widget>[
                              //         Container(
                              //           child: Text(formularioModel.creadorUsuario),
                              //           alignment: Alignment.topLeft,
                              //         ),

                              //         Container(
                              //           child: Text(formularioModel.nombre,style: TextStyle(color: Colors.white)),
                              //           alignment: Alignment.center,

                              //         ),
                              //         Container(
                              //           margin: EdgeInsets.only(left: 175,right: 2),
                              //           padding: EdgeInsets.only(right:5),
                              //           decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                              //           child:  Text('${formularioModel.usuarios.length} / 25'),
                              //           alignment: Alignment.bottomRight,
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // );
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
