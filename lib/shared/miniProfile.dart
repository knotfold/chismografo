import 'package:flutter/material.dart';
import 'package:trivia_form/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/shared/shared.dart';

class MiniProfile extends StatefulWidget {
  final UsuarioModel usuario;
  MiniProfile({this.usuario});

  @override
  _MiniProfileState createState() => _MiniProfileState();
}

class _MiniProfileState extends State<MiniProfile> {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 300,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              height: 200,
              margin: EdgeInsets.only(top: 60),
              color: backgroundColor,
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.usuario.usuario,
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(child: Text(widget.usuario.nombre)),
                        verifyMyFRequest(controller)
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: RaisedButton(
                                  child: Expanded(
                                      child: Text('Cancelar Solicitud')),
                                  onPressed: () async {
                                    await controller.usuario.reference
                                        .updateData({
                                      'solicitudesAE': FieldValue.arrayRemove(
                                          [widget.usuario.documentId])
                                    });
                                    controller.usuario.solicitudesAE
                                        .remove(widget.usuario.documentId);
                                    controller.notify();
                                  },
                                ),
                              )
                            : verifyItsFRequest(controller)
                                ? Row(
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () async {
                                          await controller.usuario.reference
                                              .updateData({
                                            'amigos': FieldValue.arrayUnion(
                                                [widget.usuario.documentId])
                                          });
                                          await widget.usuario.reference
                                              .updateData({
                                            'amigos': FieldValue.arrayUnion([
                                              controller.usuario.documentId
                                            ]),
                                            'solicitudesAE':
                                                FieldValue.arrayRemove([
                                              controller.usuario.documentId
                                            ]),
                                          });
                                          controller.usuario.amigos
                                              .add(widget.usuario.documentId);
                                          controller.notify();
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Icons.check),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await widget.usuario.reference
                                              .updateData({
                                            'solicitudesAE':
                                                FieldValue.arrayRemove([
                                              controller.usuario.documentId
                                            ])
                                          });
                                          controller.notify();
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Icons.delete_forever),
                                      )
                                    ],
                                  )
                                : verifyFriendship(controller)
                                    ? IconButton(
                                        icon: Icon(Icons.delete_forever),
                                        onPressed: () async {
                                          await controller.usuario.reference
                                              .updateData({
                                            'amigos': FieldValue.arrayRemove(
                                                [widget.usuario.documentId])
                                          });
                                          await widget.usuario.reference
                                              .updateData({
                                            'amigos': FieldValue.arrayRemove(
                                                [controller.usuario.documentId])
                                          });
                                          controller.usuario.amigos.remove(
                                              widget.usuario.documentId);
                                          controller.notify();
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    : IconButton(
                                        onPressed: () async {
                                          await controller.usuario.reference
                                              .updateData({
                                            'solicitudesAE':
                                                FieldValue.arrayUnion([
                                              widget.usuario.documentId
                                            ]),
                                          });
                                          controller.usuario.solicitudesAE
                                              .add(widget.usuario.documentId);
                                          controller.notify();
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.person_add),
                                      ),
                      ],
                    ),
                    Text('LIBRETAS'),
                    StreamBuilder(
                      stream: Firestore.instance
                          .collection('libretas')
                          .where('creadorID',
                              isEqualTo: widget.usuario.documentId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const CircularProgressIndicator();
                        List<DocumentSnapshot> documents =
                            snapshot.data.documents;
                        return documents.isEmpty
                            ? Text('Este Usuario No Tiene Libretas')
                            : ListView.builder(
                                itemCount: documents.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text('Form' + index.toString()),
                                    subtitle: Text('Participantes: 6'),
                                    trailing: IconButton(
                                      icon: Icon(Icons.search),
                                      onPressed: () {},
                                    ),
                                  );
                                },
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.usuario.foto),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool verifyFriendship(Controller controller) {
    return widget.usuario.amigos.contains(controller.usuario.documentId);
  }

  bool verifyMyFRequest(Controller controller) {
    return controller.usuario.solicitudesAE.contains(widget.usuario.documentId);
  }

  bool verifyItsFRequest(Controller controller) {
    return widget.usuario.solicitudesAE.contains(controller.usuario.documentId);
  }
}
