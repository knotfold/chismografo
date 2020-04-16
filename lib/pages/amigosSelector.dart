import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trivia_form/shared/shared.dart';
import 'package:trivia_form/services/services.dart';
import 'package:provider/provider.dart';

class AmigosSelector extends StatefulWidget {
  @override
  _AmigosSelectorState createState() => _AmigosSelectorState();
}

class _AmigosSelectorState extends State<AmigosSelector> {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text('Selecciona a los participantes', style: TextStyle(fontSize: 25),),
          StreamBuilder(
            stream: Firestore.instance
                .collection('usuarios')
                .where('amigos', arrayContains: controller.usuario.documentId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              List<DocumentSnapshot> documents = snapshot.data.documents;
              return documents.isEmpty
                  ? Text('No tienes Amigos aún :C ' )
                  : ListView.builder(
                    shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        UsuarioModel usuarioModel =
                            UsuarioModel.fromDocumentSnapshot(documents[index]);
                        
                        return ListTile(
                          title: Text(usuarioModel.nombre),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(usuarioModel.foto),
                          ),
                          trailing: Checkbox(
                              value: controller.participantes.contains(usuarioModel.documentId),   
                              onChanged: (value) {
                              
                                
                                
                                value
                                    ? controller.participantes
                                        .add(usuarioModel.documentId)
                                    : controller.participantes
                                        .remove(usuarioModel.documentId);
                                print(controller.participantes);
                                controller.notify();
                              
                               
                              }),
                        );
                      },
                    );
            },
          ),
        ],
      ),
    );
  }
}
