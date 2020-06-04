import 'package:ChisMe/services/models.dart';
import 'package:ChisMe/shared/colors.dart';
import 'package:ChisMe/shared/shared.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ChisMe/services/services.dart';
import 'package:provider/provider.dart';
import 'package:giphy_client/giphy_client.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'pages.dart';

class Chat extends StatefulWidget {
  final dynamic usuarios;
  final String nombre;
  final String foto;
  final bool group;
  final String groupID;
  final UsuarioModel usuario;

  Chat(
      {this.usuarios,
      this.nombre,
      this.foto,
      this.group,
      this.groupID,
      this.usuario});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> documents = [];
  String roomID;
  String tipo = '0';
  var imagen;
  GiphyGif _gif;

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              if (widget.group) {
                Navigator.of(context)
                    .pushNamed('/imageViewer', arguments: widget.foto);
                return;
              }
              controller.selectedUser = widget.usuario;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Perfil(
                        usuario: widget.usuario,
                      )));
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: CircleAvatar(
                maxRadius: 18,
                backgroundImage: NetworkImage(widget.foto),
              ),
            ),
          ),
        ],
        title: Row(
          children: <Widget>[
            Text(widget.nombre),
            SizedBox(width: 30),
          ],
        ),
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: FutureBuilder<String>(
                  future: getChat(widget.usuarios),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    roomID = snapshot.data;
                    return StreamBuilder(
                      stream: Firestore.instance
                          .collection('chats')
                          .document(roomID)
                          .collection('mensajes')
                          .orderBy('fecha', descending: true)
                          .limit(500)
                          .snapshots(),
                      builder: (context, snap) {
                        if (!snap.hasData) return Container();
                        documents = snap.data.documents;
                        return Container(
                          margin: EdgeInsets.only(bottom: 95),
                          child: ListView.builder(
                              controller: _scrollController,
                              reverse: true,
                              itemCount: documents.length,
                              itemBuilder: (context, index) {
                                return Mensaje(
                                  mensajeModel:
                                      MensajeModel.fromDS(documents[index]),
                                );
                              }),
                        );
                      },
                    );
                  }),
            ),
            FittedBox(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () async {
                          imagen = await controller.getImage(context);
                          setState(() {
                            if (imagen != null && _gif != null) {
                              _gif = null;
                            }
                            imagen = imagen;
                            tipo = '1';
                          });
                        }),
                    IconButton(
                        icon: Icon(Icons.gif),
                        onPressed: () async {
                          final gif = await GiphyPicker.pickGif(
                              showPreviewPage: false,
                              context: context,
                              apiKey: 'lNQ4l3vP5F2yWjHcJiVHaKyK4HEm16Q8');

                          if (gif != null) {
                            if (imagen != null) {
                              imagen = null;
                            }
                            tipo = '2';
                            setState(() => _gif = gif);
                          }
                        }),
                    Container(
                      width: 300,
                      child: imagen != null
                          ? Stack(
                              alignment: Alignment.topLeft,
                              children: <Widget>[
                                Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(imagen),
                                  height: 300,
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      imagen = null;
                                      setState(() {});
                                    }),
                              ],
                            )
                          : _gif != null
                              ? Stack(
                                  alignment: Alignment.topLeft,
                                  children: <Widget>[
                                    GiphyImage.original(
                                      gif: _gif,
                                      height: 300,
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          _gif = null;
                                          setState(() {});
                                        }),
                                  ],
                                )
                              : TextField(
                                  keyboardType: TextInputType.text,
                                  controller: textEditingController,
                                  decoration: InputDecoration(
                                      hintText: 'Mensaje',
                                      labelText: 'Mensaje',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide())),
                                  style: TextStyle(fontSize: 15),
                                  minLines: 1,
                                  maxLines: 5,
                                ),
                    ),
                    IconButton(
                        icon: CircleAvatar(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                          backgroundColor: primaryColor,
                        ),
                        onPressed: () async {
                          switch (tipo) {
                            case '0':
                              if (textEditingController.text.isEmpty ||
                                  textEditingController.text.trim() == '')
                                return;
                              await Firestore.instance
                                  .collection('chats')
                                  .document(roomID)
                                  .collection('mensajes')
                                  .add({
                                'mensaje': textEditingController.text,
                                'usuario': controller.usuario.usuario,
                                'fecha': DateTime.now(),
                                'tipo': tipo,
                              });
                              textEditingController.clear();
                              setState(() {});
                              break;
                            case '1':
                              var newImagen = imagen;
                              controller.loading = true;
                              controller.notify();

                              setState(() {
                                imagen = null;
                              });

                              final String fileName =
                                  controller.usuario.correo +
                                      '/chat/' +
                                      DateTime.now().toString();

                              StorageReference storageRef = FirebaseStorage
                                  .instance
                                  .ref()
                                  .child(fileName);

                              final StorageUploadTask uploadTask =
                                  storageRef.putFile(
                                newImagen,
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

                              await Firestore.instance
                                  .collection('chats')
                                  .document(roomID)
                                  .collection('mensajes')
                                  .add({
                                'imagen': url,
                                'usuario': controller.usuario.usuario,
                                'fecha': DateTime.now(),
                                'tipo': tipo,
                              });

                              tipo = '0';

                              controller.loading = false;

                              controller.notify();
                              break;
                            case '2':
                              controller.loading = true;
                              controller.notify();
                              GiphyGif newGif = _gif;
                              _gif = null;
                              await Firestore.instance
                                  .collection('chats')
                                  .document(roomID)
                                  .collection('mensajes')
                                  .add({
                                'gif': newGif.images.original.url,
                                'usuario': controller.usuario.usuario,
                                'fecha': DateTime.now(),
                                'tipo': tipo,
                              });

                              tipo = '0';

                              controller.loading = false;

                              controller.notify();
                              break;
                          }
                          if (documents != null) {
                            _scrollController.animateTo(
                              0.0,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 300),
                            );
                          }
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> getChat(dynamic usuarios) async {
    if (widget.group) {
      var query = await Firestore.instance
          .collection('chats')
          .document(widget.groupID)
          .get();
      if (!query.exists) {
        await Firestore.instance
            .collection('chats')
            .document(widget.groupID)
            .setData({'usuarios': usuarios});
      }
      return widget.groupID;
    }
    var query = await Firestore.instance
        .collection('chats')
        .document('${usuarios[0]}-${usuarios[1]}')
        .get();

    if (!query.exists) {
      query = await Firestore.instance
          .collection('chats')
          .document('${usuarios[1]}-${usuarios[0]}')
          .get();

      if (!query.exists) {
        await Firestore.instance
            .collection('chats')
            .document('${usuarios[0]}-${usuarios[1]}')
            .setData({'usuarios': usuarios});
        return '${usuarios[0]}-${usuarios[1]}';
      }

      return '${usuarios[1]}-${usuarios[0]}';
    }

    return '${usuarios[0]}-${usuarios[1]}';
  }
}
