import 'package:flutter/material.dart';
import 'package:trivia_form/services/services.dart';
import 'package:trivia_form/shared/shared.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    TextEditingController textEditingController = TextEditingController();
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: myAppBar(controller),
        body: ListView(
          addSemanticIndexes: true,
          addRepaintBoundaries: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  margin:
                      EdgeInsets.only(left: 20, right: 5, top: 20, bottom: 20),
                  // height: 100,
                  // width: 100,
                  child: GestureDetector(
                    onTap: () => showDialog(
                      child: WillPopScope(
                        onWillPop: () async {
                          return controller.loading ? false : true;
                        },
                        child: SimpleDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          children: <Widget>[
                            DialogContent(),
                          ],
                        ),
                      ),
                      context: context,
                    ),
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(260),
                          child: FadeInImage(
                            fit: BoxFit.cover,
                            placeholder: AssetImage('assets/gudtech.jpg'),
                            width: 100,
                            height: 100,
                            image: NetworkImage(controller.usuario.foto),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: buttonColors,
                          radius: 17,
                          child: Icon(
                            Icons.photo_camera,
                            size: 18,
                            color: Colors.white,
                          ),
                          // IconButton(
                          //   icon: Icon(Icons.photo_camera,size: 18,color: Colors.white,),
                          //   onPressed: () => null,
                          //   //=> showDialog(
                          //   //   child: WillPopScope(
                          //   //     onWillPop: () async {
                          //   //       return controller.loading ? false : true;
                          //   //     },
                          //   //     child: SimpleDialog(
                          //   //       shape: RoundedRectangleBorder(
                          //   //           borderRadius:
                          //   //               BorderRadius.circular(20)),
                          //   //       children: <Widget>[
                          //   //         DialogContent(),
                          //   //       ],
                          //   //     ),
                          //   //   ),
                          //   //   context: context,
                          //   // ),
                          // )
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // SizedBox(
                        //   height: 15,
                        // ),
                        //Icon(Icons.person, color: Colors.black, size: 30),
                        IconButton(
                          onPressed: () => showDialog(
                            context: context,
                            child: Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                margin: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    TextField(
                                      maxLength: 50,
                                      decoration:
                                          InputDecoration(labelText: 'Nombre'),
                                      controller: textEditingController,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    FloatingActionButton.extended(
                                      backgroundColor: Colors.white,
                                      onPressed: () async {
                                        controller.loading = true;
                                        controller.notify();
                                        await controller.usuario.reference
                                            .updateData({
                                          'nombre': textEditingController.text
                                        });
                                        controller.usuario.nombre =
                                            textEditingController.text;
                                        controller.loading = false;
                                        controller.notify();
                                        Navigator.of(context).pop();
                                      },
                                      label: Text(
                                        'Actualizar',
                                        style: TextStyle(color: buttonColors),
                                      ),
                                      icon: Icon(
                                        Icons.edit,
                                        color: buttonColors,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          icon: Icon(Icons.edit),
                        ),

                        Text(controller.usuario.nombre,
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.mail, color: buttonColors, size: 30),
                        SizedBox(
                          width: 15,
                        ),
                        Text(controller.usuario.correo,
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Divider(),

            SizedBox(
              height: 25,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.search, color: buttonColors, size: 30),
                SizedBox(
                  width: 25,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(controller.usuario.usuario,
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    Text(
                      'Éste es tu nombre de usuario, tus amigos pueden encontrarte\nfácilmente dentro de la aplicación con él.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(
              height: 25,
            ),
            !controller.usuario.monedasFree
                ? Container(
                  margin: EdgeInsets.only(left:10),
                  alignment: Alignment.centerLeft,
                  child: FlatButton.icon(
                      icon: Icon(Icons.stars, size: 30, color: buttonColors),
                      label: Text(
                        'Coins Free',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        return showDialog(
                            context: context,
                            child: Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: SingleChildScrollView(
                                    child: Container(
                                        margin: EdgeInsets.all(20),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(Icons.stars,
                                                    color: Colors.white,
                                                    size: 20),
                                                Text('Coins Free',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                                'Si alguien te invito a usar esta App, nosotros le agradeceremos regalandole 25 monedas. Solo puedes elgir una vez y a una persona'),
                                            FittedBox(
                                              child: ListaAmigos(),
                                            )
                                          ],
                                        )))));
                      }),
                )
                : Container(),
                SizedBox(height: 25,),
                Container(
                  margin: EdgeInsets.only(left:10),
                  alignment: Alignment.centerLeft,
                  child: FlatButton.icon(
                      icon: Icon(Icons.group_add, size: 35, color: buttonColors),
                      label: Text(
                        'Inivtar amigos',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () =>null),
                ),
            
            Container(
              
              height: 300,
              alignment: Alignment.bottomRight,
            padding: EdgeInsets.symmetric(horizontal: 40),
              child: FloatingActionButton.extended(
                icon: Icon(Icons.exit_to_app),
                label: Text('Salir'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 4,
                backgroundColor: buttonColors,
                onPressed: () async {
                  await controller.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
                },
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                   
                //     Icon(
                //       Icons.exit_to_app,
                //       color: Colors.white,
                //     ),
                //     Text('Salir'),
                //   ],
                // ),
              ),
            ),

            SizedBox(
              height: 25,
            ),

            SizedBox(
              height: 25,
            ),
            // RaisedButton(
            //   onPressed: () async {
            //     await controller.signOut();
            //     Navigator.of(context)
            //         .pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
            //   },
            //   child: Text('Cerrar Sesión'),

            // ),
          ],
        ));
  }
}

class DialogContent extends StatefulWidget {
  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  var imagen;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(
            thickness: 1,
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                width: 350,
                height: 350,
                fit: BoxFit.cover,
                image: imagen == null
                    ? NetworkImage(controller.usuario.foto)
                    : FileImage(imagen),
                placeholder: AssetImage('assets/gudtech.jpg'),
              ),
            ),
          ),
          controller.loading
              ? CircularProgressIndicator()
              : Column(
                  children: <Widget>[
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton.extended(
                          backgroundColor: Colors.white,
                          onPressed: () async {
                            imagen = await controller.getImage(context);
                            setState(() {
                              imagen = imagen;
                            });
                          },
                          label: Text(
                            'Foto Galeria',
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(
                            Icons.photo_library,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton.extended(
                          backgroundColor: Colors.white,
                          onPressed: () async {
                            imagen = await controller.getImageCamera(context);
                            setState(() {
                              imagen = imagen;
                            });
                          },
                          label: Text(
                            'Foto Camara',
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(
                            Icons.photo_camera,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton.extended(
                          backgroundColor: Colors.white,
                          onPressed: () async {
                            controller.loading = true;
                            controller.notify();

                            final String fileName = controller.usuario.correo +
                                '/perfil/' +
                                DateTime.now().toString();

                            StorageReference storageRef =
                                FirebaseStorage.instance.ref().child(fileName);

                            final StorageUploadTask uploadTask =
                                storageRef.putFile(
                              imagen,
                            );

                            final StorageTaskSnapshot downloadUrl =
                                (await uploadTask.onComplete);

                            if (controller.usuario.fotoStorageRef != null) {
                              await FirebaseStorage.instance
                                  .ref()
                                  .child((controller.usuario.fotoStorageRef))
                                  .delete()
                                  .catchError((onError) {
                                print(onError);
                              });
                            }

                            final String url =
                                (await downloadUrl.ref.getDownloadURL());
                            await controller.usuario.reference.updateData({
                              'foto': url,
                              'fotoStorageRef': downloadUrl.ref.path
                            });

                            controller.usuario.foto = url;
                            controller.usuario.fotoStorageRef =
                                downloadUrl.ref.path;

                            controller.loading = false;
                            controller.notify();

                            Navigator.of(context).pop();
                          },
                          label: Text(
                            'Guardar',
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                  ],
                ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
    ;
  }
}

class ListaAmigos extends StatefulWidget {
  @override
  _ListaAmigosState createState() => _ListaAmigosState();
}

class _ListaAmigosState extends State<ListaAmigos> {
  var selectedFriend;
  String friendId;
  bool selected = false;
  bool isLoading = false;
  int coins = 0;
  var stream;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    stream = Firestore.instance
        .collection('usuarios')
        .where('amigos', arrayContains: controller.usuario.documentId)
        .snapshots();
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          List<DropdownMenuItem> listItems = [];
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            for (int i = 0; i < snapshot.data.documents.length; i++) {
              DocumentSnapshot snap = snapshot.data.documents[i];

              listItems.add(
                DropdownMenuItem(
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(snap['foto']),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(snap['nombre']),
                          Text(snap['usuario']),
                        ],
                      ),
                    ],
                  ),
                  value: i,
                ),
              );
            }
            return Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton(
                        items: listItems,
                        onChanged: (value) {
                          setState(() {
                            friendId =
                                snapshot.data.documents[value].documentID;

                            coins = snapshot.data.documents[value]['coins'];

                            selectedFriend = value;

                            setState(() {});

                            controller.notify();
                          });
                        },
                        value: selectedFriend,
                        isExpanded: false,
                        hint: Text(
                          "Selecciona a un amigo",
                        ),
                      )
                    ]),
                isLoading
                    ? CircularProgressIndicator()
                    : selectedFriend == '' || selectedFriend == null
                        ? Container()
                        : RaisedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await Firestore.instance
                                  .collection('usuarios')
                                  .document(friendId)
                                  .updateData({'coins': coins + 25});

                              await controller.usuario.reference
                                  .updateData({'monedasFree': true});

                              controller.usuario.monedasFree = true;

                              controller.notify();
                              print(selectedFriend);
                              print(friendId);

                              setState(() {
                                isLoading = false;
                              });

                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Aceptar',
                              style: TextStyle(color: buttonColors),
                            ))
              ],
            );
          }
        });
  }
}
