import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ChisMe/services/services.dart';
import 'package:provider/provider.dart';

class AmigosSelec extends StatefulWidget {
  @override
  _AmigosSelec createState() => _AmigosSelec();
}

class _AmigosSelec extends State<AmigosSelec> {
  bool checkInvitado(String id, Controller controller) {
    for (var usuario in controller.toFillForm.invitaciones) {
      if (usuario == id) {
        return false;
      }
    }

    for (var usuario in controller.toFillForm.usuarios) {
      if (usuario == id) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                                  child: Text(
                    'Selecciona a los participantes (${controller.toFillForm.invitaciones.length + controller.toFillForm.usuarios.length + controller.participantes.length}/25)',
                    style: TextStyle(fontSize: 20,color: Colors.white),
                  ),
                ),
                FloatingActionButton.extended(
                  heroTag: 'btn2',
                  onPressed: () async {
                    if ((controller.toFillForm.invitaciones.length +
                            controller.toFillForm.usuarios.length +
                            controller.participantes.length) >
                        25) {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            title: Text('No puedes'),
                          ));
                      return;
                    }
                    await controller.toFillForm.reference.updateData({
                      'invitaciones':
                          FieldValue.arrayUnion(controller.participantes)
                    });

                    controller.participantes.clear();

                    print('nice');
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  label: Text('Invitar'),
                ),
              ],
            ),
            SizedBox(height: 10,),
            StreamBuilder(
              stream: Firestore.instance
                  .collection('usuarios')
                  .where('amigos', arrayContains: controller.usuario.documentId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                List<DocumentSnapshot> documents = snapshot.data.documents;
                return documents.isEmpty
                    ? Text('No tienes Amigos :(',style: TextStyle(color: Colors.white),)
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          UsuarioModel usuarioModel =
                              UsuarioModel.fromDocumentSnapshot(
                                  documents[index], controller.usuario.usuario);
                          return !checkInvitado(
                                      usuarioModel.usuario, controller) ||
                                  controller.toFillForm.creadorUsuario ==
                                      usuarioModel.usuario
                              ? Container()
                              : ListTile(
                                  title: Text(usuarioModel.nombre,style: TextStyle(color: Colors.white)),
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(usuarioModel.foto),
                                  ),
                                  trailing: Checkbox(
                                      value: controller.participantes
                                          .contains(usuarioModel.usuario),
                                      onChanged: (value) {
                                        if (value) {
                                          if ((controller.toFillForm
                                                      .invitaciones.length +
                                                  controller.toFillForm.usuarios
                                                      .length +
                                                  controller
                                                      .participantes.length) >=
                                              25) {
                                            showDialog(
                                                context: context,
                                                child: Dialog(
                                                  child: AlertDialog(
                                                    title: Text(
                                                        'El limite Maximo de participantes es 25',style: TextStyle(color: Colors.white)),
                                                  ),
                                                ));
                                            return;
                                          }
                                          controller.participantes
                                              .add(usuarioModel.usuario);

                                          print(controller.participantes);
                                          controller.notify();
                                          return;
                                        } else {
                                          controller.participantes
                                              .remove(usuarioModel.usuario);

                                          print(controller.participantes);

                                          controller.notify();
                                        }
                                      }),
                                );
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
