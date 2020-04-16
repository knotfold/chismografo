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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Container(
        width: double.maxFinite,
        height: 280,

        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(20)),
          
              width: double.maxFinite,
              margin: EdgeInsets.only(top: 60),
              alignment: Alignment.topCenter,
              child: Container(
              
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 20,left: 20,right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(

                      height: 30,
                    ),
                    Container(
                      child: Text(widget.usuario.nombre,
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      alignment: Alignment.center,
                    ),
                    SizedBox(
                      height: 20),
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
                    Container(
                      height:70 ,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                           Expanded(child: Text(widget.usuario.nombre)),
                          verifyMyFRequest(controller)
                              ? Container(
                                width: 280,
                                 alignment: Alignment.bottomRight,
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
                                    elevation: 1,
                                    splashColor: Colors.blueGrey[100],
                                    color: Colors.blueGrey
                                  ),
                                )
                              : verifyItsFRequest(controller)
                                  ? Row(
                                      children: <Widget>[
                                        Container(
                                          width: 280,
                                        alignment: Alignment.bottomRight,
                                          child: IconButton(
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
                                            iconSize: 35,
                                          ),
                                        ),
                                        Container(
                                          width: 280,
                                        alignment: Alignment.bottomRight,
                                          child: IconButton(
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
                                            iconSize: 35,
                                          ),
                                        )
                                      ],
                                    )
                                  : verifyFriendship(controller)
                                      ? Container(
                                        width: 280,
                                        alignment: Alignment.bottomRight,
                                        child: IconButton(
                                            icon: Icon(Icons.delete_forever),
                                            iconSize: 35,
                                            onPressed: () async {
                                              await controller.usuario.reference
                                                  .updateData({
                                                'amigos': FieldValue.arrayRemove(
                                                    [widget.usuario.documentId])
                                              });
                                              await widget.usuario.reference
                                                  .updateData({
                                                'amigos': FieldValue.arrayRemove([
                                                  controller.usuario.documentId
                                                ])
                                              });
                                              controller.usuario.amigos.remove(
                                                  widget.usuario.documentId);
                                              controller.notify();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                      )
                                      : Container(
                                        
                                        width: 280,
                                        alignment: Alignment.bottomRight,
                                        child: IconButton(

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
                                            
                                            iconSize: 35,
                                          ),
                                      ),
                        ],
                      ),
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
