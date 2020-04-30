import 'package:flutter/material.dart';
import 'package:trivia_form/shared/libretaCard.dart';
import 'package:trivia_form/shared/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/services/services.dart';

class TusLibretas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'btnT1',
        isExtended: true,
        splashColor: secondaryColor,
        onPressed: () => Navigator.of(context).pushNamed('/creadorLibreta'),
        label: Text('Nueva libreta'),
        icon: Icon(Icons.book),
      ),
      appBar: myAppBar(controller, context),
      body: SingleChildScrollView(
              child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Tus Libretas',
                style: TextStyle(fontSize: 22),
              ),
              Container(
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('formularios')
                      .where('creadorID',
                          isEqualTo: controller.usuario.documentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const CircularProgressIndicator();
                    List<DocumentSnapshot> documents = snapshot.data.documents;

                    return documents.isEmpty
                        ? Text('No tienes Libretas')
                        : ListView.builder(

                            physics: NeverScrollableScrollPhysics(),
                            itemCount: documents.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              FormularioModel formularioModel =
                                  FormularioModel.fromDS(documents[index]);
                              return  LibretaCard(formularioModel: formularioModel,controller: controller);
                              
                              // ListTile(
                              //   onTap: () {
                              //     controller.toFillForm = formularioModel;
                              //     Navigator.of(context)
                              //         .pushNamed('/libretaDetalles');
                              //   },
                              //   title: Text(
                              //     formularioModel.nombre,
                              //     style: TextStyle(fontSize: 20),
                              //   ),
                              //   subtitle: Text('Tu libreta'),
                              //   trailing: Text(
                              //       '${formularioModel.usuarios.length} / 25'),
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
