import 'package:flutter/material.dart';
import 'package:ChisMe/services/services.dart';
import 'package:ChisMe/shared/shared.dart';
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
        appBar: myAppBar(controller, context),
        body: FutureBuilder(
            future: controller.rebuildUser(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const LinearProgressIndicator();
              return ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 5, top: 20, bottom: 20),
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
                                backgroundColor: pDark,
                                radius: 15,
                                child: Icon(
                                  Icons.photo_camera,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
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
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Container(
                                        margin: EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            TextField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              maxLength: 50,
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                      color: Colors.white),
                                                  labelText: 'Nombre'),
                                              controller: textEditingController,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            FloatingActionButton.extended(
                                              onPressed: () async {
                                                controller.loading = true;
                                                controller.notify();
                                                await controller
                                                    .usuario.reference
                                                    .updateData({
                                                  'nombre':
                                                      textEditingController.text
                                                });
                                                controller.usuario.nombre =
                                                    textEditingController.text;
                                                controller.loading = false;
                                                controller.notify();
                                                Navigator.of(context).pop();
                                              },
                                              label: Text(
                                                'Actualizar',
                                              ),
                                              icon: Icon(
                                                Icons.edit,
                                                size: 20,
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
                                      fontSize: 18,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(Icons.mail, size: 20),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Text(
                                      controller.usuario.correo ?? 'Sin correo',
                                      style: TextStyle(
                                        fontSize: 18,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 40),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.assistant, size: 20),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(controller.usuario.usuario,
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),
                              Text(
                                'Éste es tu nombre de usuario, tus amigos pueden encontrarte fácilmente dentro de la aplicación con él.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: sDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 10),
                  // Container(
                  //   margin: EdgeInsets.only(left: 10),
                  //   alignment: Alignment.centerLeft,
                  //   child: FlatButton.icon(
                  //     icon: Icon(
                  //       Icons.group_add,
                  //       size: 20,
                  //       color: pDark,
                  //     ),
                  //     label: Text(
                  //       'Inivtar amigos',
                  //       style: TextStyle(fontSize: 18, color: Colors.black),
                  //     ),
                  //     onPressed: () => null,
                  //   ),
                  // ),
                  !controller.usuario.monedasFree
                      ? Container(
                          margin: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: FlatButton.icon(
                            icon: Icon(
                              Icons.stars,
                              size: 20,
                              color: pDark,
                            ),
                            label: Text(
                              'Monedas Gratis',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            onPressed: () {
                              return showDialog(
                                context: context,
                                child: Dialog(
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(20)),
                                  backgroundColor: Colors.white,
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
                                              Icon(
                                                Icons.stars,
                                                size: 20,
                                                color: secondaryColor,
                                              ),
                                              Text('Monedas Gratis',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                              'Si alguien te invito a usar esta App, nosotros le agradeceremos regalandole 25 monedas. Solo puedes elegir una vez y a una persona'),
                                          FittedBox(
                                            child: ListaAmigos(),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: FlatButton.icon(
                      icon: Icon(
                        Icons.cancel,
                        size: 20,
                        color: pDark,
                      ),
                      label: Text(
                        'Usuarios Bloqueados',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            child: Dialog(
                              backgroundColor: Colors.white,
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('usuarios')
                                      .where('bloqueados',
                                          arrayContains:
                                              controller.usuario.usuario)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return const LinearProgressIndicator();

                                    List<DocumentSnapshot> documents =
                                        snapshot.data.documents;
                                    return documents.isEmpty
                                        ? Text('No tienes usuarios bloqueados')
                                        : ListView.builder(
                                            itemCount: documents.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              UsuarioModel usuario =
                                                  UsuarioModel
                                                      .fromDocumentSnapshot(
                                                          documents[index]);
                                              return ListTile(
                                                subtitle: Text(usuario.usuario,
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      usuario.foto),
                                                ),
                                                title: Text(usuario.nombre,
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                trailing: controller.loading
                                                    ? CircularProgressIndicator()
                                                    : Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          RaisedButton(
                                                            color: Colors.white,
                                                            onPressed:
                                                                () async {
                                                              controller
                                                                      .loading =
                                                                  true;
                                                              controller
                                                                  .notify();
                                                              await usuario
                                                                  .reference
                                                                  .updateData({
                                                                'bloqueados':
                                                                    FieldValue
                                                                        .arrayRemove([
                                                                  controller
                                                                      .usuario
                                                                      .usuario
                                                                ])
                                                              });
                                                              controller.loading = false;
                                                              controller.notify();
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text(
                                                              'Desbloquear',
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                              );
                                            },
                                          );
                                  },
                                ),
                              ),
                            ));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: FloatingActionButton.extended(
                      icon: Icon(Icons.power_settings_new),
                      label: Text('Cerrar Sesión'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 4,

                      onPressed: () async {
                        await controller.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/', ModalRoute.withName('/'));
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
                  controller.usuario.usuario == '@GAV' ||
                          controller.usuario.usuario == '@Cammy'
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          child: FloatingActionButton.extended(
                            heroTag: 'meh',
                            icon: Icon(Icons.restore),
                            label: Text('Reset'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 4,
                            onPressed: () async {
                              Firestore.instance
                                  .collection('reset')
                                  .document('reset')
                                  .updateData({'reset': true});
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
                        )
                      : Container(),
                ],
              );
            }));
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
                          heroTag: 'perfil2',
                          onPressed: () async {
                            imagen = await controller.getImage(context);
                            setState(() {
                              imagen = imagen;
                            });
                          },
                          label: Text(
                            'Foto Galeria',
                          ),
                          icon: Icon(
                            Icons.photo_library,
                          ),
                        )
                      ],
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton.extended(
                          heroTag: 'perfil3',
                          onPressed: () async {
                            imagen = await controller.getImageCamera(context);
                            setState(() {
                              imagen = imagen;
                            });
                          },
                          label: Text(
                            'Foto Camara',
                          ),
                          icon: Icon(
                            Icons.photo_camera,
                          ),
                        )
                      ],
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton.extended(
                          heroTag: 'perfil4',
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

                            Navigator.pop(context);
                          },
                          label: Text(
                            'Guardar',
                          ),
                          icon: Icon(
                            Icons.save,
                          ),
                        )
                      ],
                    )
                  ],
                ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
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
            return !controller.usuario.monedasFree
                ? Column(
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

                                  coins =
                                      snapshot.data.documents[value]['coins'];

                                  selectedFriend = value;

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
                          ? Center(child: CircularProgressIndicator())
                          : selectedFriend == '' || selectedFriend == null
                              ? Container()
                              : RaisedButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        child: AlertDialog(
                                          title: Text(
                                              '¿Estas seguro de esta decisión?'),
                                          content: Text(
                                              'Ten en cuenta que solo podrás realizar esta acción una vez.'),
                                          actions: <Widget>[
                                            RaisedButton(
                                                color: Colors.white,
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(),
                                                )),
                                            RaisedButton(
                                                color: Colors.white,
                                                onPressed: () async {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  await Firestore.instance
                                                      .collection('usuarios')
                                                      .document(friendId)
                                                      .updateData({
                                                    'coins': coins + 25
                                                  });
                                                  await controller
                                                      .usuario.reference
                                                      .updateData({
                                                    'coins': controller
                                                            .usuario.coins +
                                                        25,
                                                    'monedasFree': true
                                                  });

                                                  controller.usuario
                                                      .monedasFree = true;

                                                  controller.usuario.coins =
                                                      controller.usuario.coins +
                                                          25;

                                                  controller.notify();

                                                  setState(() {
                                                    isLoading = false;
                                                    controller.usuario
                                                        .monedasFree = true;
                                                  });

                                                  controller.notify();

                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Sí',
                                                ))
                                          ],
                                        ));
                                  },
                                  child: Text(
                                    'Aceptar',
                                    style: TextStyle(color: Colors.black),
                                  ))
                    ],
                  )
                : Container();
          }
        });
  }
}
