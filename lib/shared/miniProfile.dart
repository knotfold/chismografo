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
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Container(
        width: double.maxFinite,
        height: !controller.usuario.monedasFree ? 350 : 200,
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
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          widget.usuario.nombre,
                          style: TextStyle(fontSize: 20),
                        )),
                   
                        controller.usuario.documentId ==
                                widget.usuario.documentId
                            ? Container()
                            : verifyMyFRequest(controller)
                                ? Expanded(
                                    //margin: EdgeInsets.symmetric(horizontal: 5),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      color: buttonColors,
                                      child: Text(
                                        'Cancelar Solicitud',
                                        style: TextStyle(color: Colors.white,fontSize: 13.0),
                                      ),
                                      onPressed: () async {
                                        print(widget.usuario.documentId.length);
                                        await controller.usuario.reference
                                            .updateData({
                                          'solicitudesAE':
                                              FieldValue.arrayRemove(
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
                                                'amigos':
                                                    FieldValue.arrayUnion([
                                                  controller.usuario.documentId
                                                ]),
                                                'solicitudesAE':
                                                    FieldValue.arrayRemove([
                                                  controller.usuario.documentId
                                                ]),
                                              });
                                              controller.usuario.amigos.add(
                                                  widget.usuario.documentId);
                                              controller.usuario.solicitudesAE
                                                  .remove(widget
                                                      .usuario.documentId);
                                              controller.notify();
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(
                                              Icons.check,
                                              size: 30,
                                            ),
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
                                            icon: Icon(
                                              Icons.delete_forever,
                                              size: 30,
                                            ),
                                          )
                                        ],
                                      )
                                    : verifyFriendship(controller)
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.delete_forever,
                                              size: 30,
                                            ),
                                            onPressed: () async {
                                              await controller.usuario.reference
                                                  .updateData({
                                                'amigos':
                                                    FieldValue.arrayRemove([
                                                  widget.usuario.documentId
                                                ])
                                              });
                                              await widget.usuario.reference
                                                  .updateData({
                                                'amigos':
                                                    FieldValue.arrayRemove([
                                                  controller.usuario.documentId
                                                ])
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
                                                  .add(widget
                                                      .usuario.documentId);
                                              controller.notify();
                                              setState(() {});
                                            },
                                            icon: Icon(
                                              Icons.person_add,
                                              size: 30,
                                            ),
                                          ),
                      ],
                    ),
                    Expanded(child: Text(widget.usuario.usuario)),
                    !controller.usuario.monedasFree
                        ? isLoading
                            ? Center(child: CircularProgressIndicator())
                            : Center(
                                child: Column(
                                  children: <Widget>[
                                    
                                    Text(
                                        'Si este usuario te invito a usar esta App, nosotros les agradeceremos regalandole 25 monedas a cada uno. Solo puedes elgir una vez y a una persona'),
                                    RaisedButton(

                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        color: buttonColors,

                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              child: AlertDialog(
                                                title: Text(
                                                    '¿Estas seguro de esta decisión?'),
                                                content: Text(
                                                    'Ten en cuenta que solo podrás realizar esta acción una vez.'),
                                                actions: <Widget>[
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        'No',
                                                        style: TextStyle(
                                                            color:buttonColors),
                                                      )),
                                                  FlatButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          isLoading = true;
                                                        });


                                          await Firestore.instance
                                              .collection('usuarios')
                                              .document(
                                                  widget.usuario.documentId)
                                              .updateData({
                                            'coins': widget.usuario.coins + 25
                                          });

                                          await controller.usuario.reference
                                              .updateData({
                                            'coins':
                                                controller.usuario.coins + 25
                                          });


                                                        await controller
                                                            .usuario.reference
                                                            .updateData({
                                                          'coins': controller
                                                                  .usuario
                                                                  .coins +
                                                              25
                                                        });

                                                        await controller
                                                            .usuario.reference
                                                            .updateData({
                                                          'monedasFree': true
                                                        });

                                          controller.usuario.coins =
                                              controller.usuario.coins + 25;


                                                        controller.usuario
                                                            .coins = controller
                                                                .usuario.coins +
                                                            25;

                                                        controller.notify();

                                                        print(widget.usuario
                                                            .documentId);

                                                        setState(() {
                                                          isLoading = false;
                                                        });

                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        'Sí',
                                                        style: TextStyle(
                                                            color:buttonColors),
                                                      ))
                                                ],
                                              ));

                                        },
                                        child: Text(
                                          'Regalar monedas ',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ],
                                ),
                              )
                        : Container(),
                    SizedBox(
                      height: 20,
                    )

                    // SizedBox(
                    //   height: 20),
                    // Text('LIBRETAS'),
                    // StreamBuilder(
                    //   stream: Firestore.instance
                    //       .collection('libretas')
                    //       .where('creadorID',
                    //           isEqualTo: widget.usuario.documentId)
                    //       .snapshots(),
                    //   builder: (context, snapshot) {
                    //     if (!snapshot.hasData)
                    //       return const CircularProgressIndicator();
                    //     List<DocumentSnapshot> documents =
                    //         snapshot.data.documents;
                    //     return documents.isEmpty
                    //         ? Text('Este Usuario No Tiene Libretas')
                    //         : ListView.builder(
                    //             itemCount: documents.length,
                    //             shrinkWrap: true,
                    //             itemBuilder: (context, index) {
                    //               return ListTile(
                    //                 title: Text('Form' + index.toString()),
                    //                 subtitle: Text('Participantes: 6'),
                    //                 trailing: IconButton(
                    //                   icon: Icon(Icons.search),
                    //                   onPressed: () {},
                    //                 ),
                    //               );
                    //             },
                    //           );
                    //   },
                    // ),
                    // Container(
                    //   height:70 ,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: <Widget>[
                    //       SizedBox(
                    //         height: 30,
                    //       ),
                    //     //   Expanded(child: Text(widget.usuario.nombre)),
                    //       verifyMyFRequest(controller)
                    //           ? Container(
                    //             width: 280,
                    //              alignment: Alignment.bottomRight,
                    //               child: RaisedButton(
                    //                 child: Text('Cancelar Solicitud'),
                    //                 onPressed: () async {
                    //                   await controller.usuario.reference
                    //                       .updateData({
                    //                     'solicitudesAE': FieldValue.arrayRemove(
                    //                         [widget.usuario.documentId])
                    //                   });
                    //                   controller.usuario.solicitudesAE
                    //                       .remove(widget.usuario.documentId);
                    //                   controller.notify();
                    //                 },
                    //                 elevation: 1,
                    //                 splashColor: Colors.blueGrey[100],
                    //                 color: Colors.blueGrey
                    //               ),
                    //             )
                    //           : verifyItsFRequest(controller)
                    //               ? Row(
                    //                   children: <Widget>[
                    //                     Container(
                    //                       width: 280,
                    //                     alignment: Alignment.bottomRight,
                    //                       child: IconButton(
                    //                         onPressed: () async {
                    //                           await controller.usuario.reference
                    //                               .updateData({
                    //                             'amigos': FieldValue.arrayUnion(
                    //                                 [widget.usuario.documentId])
                    //                           });
                    //                           await widget.usuario.reference
                    //                               .updateData({
                    //                             'amigos': FieldValue.arrayUnion([
                    //                               controller.usuario.documentId
                    //                             ]),
                    //                             'solicitudesAE':
                    //                                 FieldValue.arrayRemove([
                    //                               controller.usuario.documentId
                    //                             ]),
                    //                           });
                    //                           controller.usuario.amigos
                    //                               .add(widget.usuario.documentId);
                    //                           controller.notify();
                    //                           Navigator.of(context).pop();
                    //                         },
                    //                         icon: Icon(Icons.check),
                    //                         iconSize: 35,
                    //                       ),
                    //                     ),
                    //                     Container(
                    //                       width: 280,
                    //                     alignment: Alignment.bottomRight,
                    //                       child: IconButton(
                    //                         onPressed: () async {
                    //                           await widget.usuario.reference
                    //                               .updateData({
                    //                             'solicitudesAE':
                    //                                 FieldValue.arrayRemove([
                    //                               controller.usuario.documentId
                    //                             ])
                    //                           });
                    //                           controller.notify();
                    //                           Navigator.of(context).pop();
                    //                         },
                    //                         icon: Icon(Icons.delete_forever),
                    //                         iconSize: 35,
                    //                       ),
                    //                     )
                    //                   ],
                    //                 )
                    //               : verifyFriendship(controller)
                    //                   ? Container(
                    //                     width: 280,
                    //                     alignment: Alignment.bottomRight,
                    //                     child: IconButton(
                    //                         icon: Icon(Icons.delete_forever),
                    //                         iconSize: 35,
                    //                         onPressed: () async {
                    //                           await controller.usuario.reference
                    //                               .updateData({
                    //                             'amigos': FieldValue.arrayRemove(
                    //                                 [widget.usuario.documentId])
                    //                           });
                    //                           await widget.usuario.reference
                    //                               .updateData({
                    //                             'amigos': FieldValue.arrayRemove([
                    //                               controller.usuario.documentId
                    //                             ])
                    //                           });
                    //                           controller.usuario.amigos.remove(
                    //                               widget.usuario.documentId);
                    //                           controller.notify();
                    //                           Navigator.of(context).pop();
                    //                         },
                    //                       ),
                    //                   )
                    //                   : Container(

                    //                     width: 280,
                    //                     alignment: Alignment.bottomRight,
                    //                     child: IconButton(

                    //                         onPressed: () async {
                    //                           await controller.usuario.reference
                    //                               .updateData({
                    //                             'solicitudesAE':
                    //                                 FieldValue.arrayUnion([
                    //                               widget.usuario.documentId
                    //                             ]),
                    //                           });
                    //                           controller.usuario.solicitudesAE
                    //                               .add(widget.usuario.documentId);
                    //                           controller.notify();
                    //                           setState(() {});
                    //                         },
                    //                         icon: Icon(Icons.person_add),

                    //                         iconSize: 35,
                    //                       ),
                    //                   ),
                    //     ],
                    //   ),
                    // ),
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
