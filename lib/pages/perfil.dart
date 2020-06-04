import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ChisMe/services/services.dart';
import 'package:provider/provider.dart';
import 'package:ChisMe/shared/shared.dart';
class Perfil extends StatefulWidget {
  final UsuarioModel usuario;
  const Perfil({
    Key key,
    @required this.usuario
  }) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
   UsuarioModel usuario;
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    
    if(widget.usuario != null) {
         usuario = widget.usuario;
    }else{
      usuario = controller.usuario;
    }
    TextEditingController textEditingController = TextEditingController();
    return Scaffold(
        appBar: myAppBar(controller, context),
        body: DecoratedBox(
          position: DecorationPosition.background,
          decoration: BoxDecoration(
            color: usuario.fotoPortada == null || usuario.fotoPortada == ''
                ? sLight
                : Color(0xffffffff),
            image: DecorationImage(
                image: NetworkImage(usuario.fotoPortada), fit: BoxFit.cover),
          ),
          child: FutureBuilder(
              future: controller.rebuildUser(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const LinearProgressIndicator();
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              color: Colors.black38,
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(
                                      height: usuario.documentId ==
                                              controller.usuario.documentId
                                          ? MediaQuery.of(context).size.height /
                                              1.9
                                          : MediaQuery.of(context).size.height /
                                              1.55),
                                  GestureDetector(
                                    onTap: () => usuario.documentId ==
                                            controller.usuario.documentId
                                        ? showDialog(
                                            child: WillPopScope(
                                              onWillPop: () async {
                                                return controller.loading
                                                    ? false
                                                    : true;
                                              },
                                              child: SimpleDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                children: <Widget>[
                                                  DialogContent(
                                                    foto: 'perfil',
                                                  ),
                                                ],
                                              ),
                                            ),
                                            context: context,
                                          )
                                        : null,
                                    child: usuario.documentId ==
                                            controller.usuario.documentId
                                        ? Stack(
                                            alignment: Alignment.topRight,
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: FadeInImage(
                                                  fit: BoxFit.cover,
                                                  placeholder: AssetImage(
                                                      'assets/gudtech.jpg'),
                                                  width: 85,
                                                  height: 85,
                                                  image: NetworkImage(
                                                     usuario.foto),
                                                ),
                                              ),
                                              CircleAvatar(
                                                backgroundColor: pDark,
                                                radius: 13,
                                                child: Icon(
                                                  Icons.photo_camera,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(260),
                                            child: FadeInImage(
                                              fit: BoxFit.cover,
                                              placeholder: AssetImage(
                                                  'assets/gudtech.jpg'),
                                              width: 85,
                                              height: 85,
                                              image: NetworkImage(usuario.foto),
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Spacer(
                                        flex: 2,
                                      ),
                                      Text(usuario.nombre,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white)),
                                      usuario.documentId ==
                                              controller.usuario.documentId
                                          ? IconButton(
                                              onPressed: () => showDialog(
                                                context: context,
                                                child: Dialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Container(
                                                    margin: EdgeInsets.all(20),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        TextField(
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          maxLength: 30,
                                                          decoration: InputDecoration(
                                                              labelStyle: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              labelText:
                                                                  'Nombre'),
                                                          controller:
                                                              textEditingController,
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        FloatingActionButton
                                                            .extended(
                                                          onPressed: () async {
                                                            controller.loading =
                                                                true;

                                                            controller.notify();

                                                            await controller
                                                                .usuario
                                                                .reference
                                                                .updateData({
                                                              'nombre':
                                                                  textEditingController
                                                                      .text
                                                            });

                                                            controller.usuario
                                                                    .nombre =
                                                                textEditingController
                                                                    .text;

                                                            usuario.documentId =
                                                                textEditingController
                                                                    .text;

                                                            controller.loading =
                                                                false;

                                                            controller.notify();

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
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
                                              icon: Icon(
                                                Icons.edit,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Container(),
                                      Spacer(
                                        flex: 2,
                                      )
                                    ],
                                  ),
                                  Text(usuario.usuario,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      )),
                                  usuario.documentId ==
                                          controller.usuario.documentId
                                      ? ButtonBar(
                                          alignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            !controller.usuario.monedasFree
                                                ? FlatButton.icon(
                                                    icon: Icon(
                                                      Icons.stars,
                                                      size: 20,
                                                      color: Colors.white,
                                                    ),
                                                    label: Text(
                                                      'Monedas \nGratis',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      return showDialog(
                                                        context: context,
                                                        child: Dialog(
                                                          backgroundColor:
                                                              Colors.white,
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .all(20),
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .stars,
                                                                        size:
                                                                            20,
                                                                        color:
                                                                            secondaryColor,
                                                                      ),
                                                                      Text(
                                                                          'Monedas Gratis',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                          ))
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Text(
                                                                      'Si alguien te invito a usar esta App, nosotros le agradeceremos regalandole 25 monedas. Solo puedes elegir una vez y a una persona'),
                                                                  FittedBox(
                                                                    child:
                                                                        ListaAmigos(),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : Container(),
                                            FlatButton.icon(
                                              icon: Icon(
                                                Icons.cancel,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              label: Text(
                                                'Usuarios \nBloqueados',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    child: Dialog(
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.all(5),
                                                        child: StreamBuilder(
                                                          stream: Firestore
                                                              .instance
                                                              .collection(
                                                                  'usuarios')
                                                              .where(
                                                                  'bloqueados',
                                                                  arrayContains:
                                                                      controller
                                                                          .usuario
                                                                          .usuario)
                                                              .snapshots(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (!snapshot
                                                                .hasData)
                                                              return const LinearProgressIndicator();

                                                            List<DocumentSnapshot>
                                                                documents =
                                                                snapshot.data
                                                                    .documents;

                                                            return documents
                                                                    .isEmpty
                                                                ? Text(
                                                                    'No tienes usuarios bloqueados')
                                                                : ListView
                                                                    .builder(
                                                                    itemCount:
                                                                        documents
                                                                            .length,
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      UsuarioModel
                                                                          user =
                                                                          UsuarioModel.fromDocumentSnapshot(
                                                                              documents[index]);

                                                                      return ListTile(
                                                                        subtitle: Text(
                                                                            user
                                                                                .usuario,
                                                                            style:
                                                                                TextStyle(color: Colors.black)),
                                                                        leading:
                                                                            CircleAvatar(
                                                                          backgroundImage:
                                                                              NetworkImage(user.foto),
                                                                        ),
                                                                        title: Text(
                                                                            user
                                                                                .nombre,
                                                                            style:
                                                                                TextStyle(color: Colors.black)),
                                                                        trailing: controller.loading
                                                                            ? CircularProgressIndicator()
                                                                            : Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: <Widget>[
                                                                                  RaisedButton(
                                                                                    color: Colors.white,
                                                                                    onPressed: () async {
                                                                                      controller.loading = true;

                                                                                      controller.notify();

                                                                                      await user.reference.updateData({
                                                                                        'bloqueados': FieldValue.arrayRemove([
                                                                                          controller.usuario.usuario
                                                                                        ])
                                                                                      });

                                                                                      controller.loading = false;

                                                                                      controller.notify();

                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                    child: Text(
                                                                                      'Desbloquear',
                                                                                      style: TextStyle(fontSize: 10, color: Colors.black),
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
                                            )
                                          ],
                                        )
                                      : MiniProfile(
                                          usuario: usuario,
                                        ),
                                ],
                              ),
                            ),
                          ),
                          usuario.documentId == controller.usuario.documentId
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(top: 15),
                                      child: StreamBuilder(
                                          stream: controller.usuario.reference
                                              .collection('preguntas')
                                              .where('respuesta', isEqualTo: "")
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData)
                                              return const Icon(Icons.person);
                                            List<DocumentSnapshot> documents =
                                                snapshot.data.documents;
                                            return documents.isEmpty
                                                ? RaisedButton(
                                                    padding: EdgeInsets.all(6),
                                                    elevation: 4,
                                                    color: pDark,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          'Preguntas Anónimas',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10),
                                                        ),
                                                        Icon(
                                                          Icons.help_outline,
                                                          size: 17,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          child: Dialog(
                                                            child: Container(
                                                              height: 200,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(15),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    'Preguntas',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        color: Colors
                                                                            .white),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child: StreamBuilder(
                                                                        stream: controller.usuario.reference
                                                                            .collection(
                                                                              'preguntas',
                                                                            )
                                                                            .where('respuesta', isEqualTo: "")
                                                                            .orderBy('fecha')
                                                                            .snapshots(),
                                                                        builder: (context, snapshot) {
                                                                          if (!snapshot
                                                                              .hasData)
                                                                            return const CircularProgressIndicator();

                                                                          List<DocumentSnapshot>
                                                                              documents =
                                                                              snapshot.data.documents;

                                                                          return documents.isEmpty
                                                                              ? Container(
                                                                                  margin: EdgeInsets.only(top: 20),
                                                                                  child: Text(
                                                                                    'No tienes preguntas por el momento',
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                )
                                                                              : ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  itemCount: documents.length,
                                                                                  itemBuilder: (BuildContext context, int index) {
                                                                                    PreguntaModel preguntaModel = PreguntaModel.fromDocumentSnapshot(documents[index]);

                                                                                    return GestureDetector(
                                                                                      onTap: () {
                                                                                        controller.preguntaModel = preguntaModel;
                                                                                        print(preguntaModel.pregunta);
                                                                                        preguntaModel.respuesta.isEmpty
                                                                                            ? showDialog(
                                                                                                context: context,
                                                                                                child: SimpleDialog(
                                                                                                  backgroundColor: Colors.white,
                                                                                                  contentPadding: EdgeInsets.all(0),
                                                                                                  children: <Widget>[DialogRespuesta()],
                                                                                                ))
                                                                                            : null;
                                                                                      },
                                                                                      child: ListTile(
                                                                                          title: Text(
                                                                                            preguntaModel.pregunta,
                                                                                            style: TextStyle(color: Colors.white),
                                                                                          ),
                                                                                          trailing: Icon(
                                                                                            preguntaModel.respuesta.isEmpty ? Icons.question_answer : Icons.check,
                                                                                            color: Colors.white,
                                                                                          )),
                                                                                    );
                                                                                  },
                                                                                );
                                                                        }),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ));
                                                    },
                                                  )
                                                : Stack(
                                                    children: <Widget>[
                                                      RaisedButton(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        elevation: 4,
                                                        color: pDark,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text(
                                                              'Pregunta nueva',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .help_outline,
                                                              size: 17,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          ],
                                                        ),
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              child: Dialog(
                                                                child:
                                                                    Container(
                                                                  height: 200,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              15),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        'Preguntas',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.white),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Expanded(
                                                                        child: StreamBuilder(
                                                                            stream: controller.usuario.reference
                                                                                .collection(
                                                                                  'preguntas',
                                                                                )
                                                                                .where('respuesta', isEqualTo: "")
                                                                                .orderBy('fecha')
                                                                                .snapshots(),
                                                                            builder: (context, snapshot) {
                                                                              if (!snapshot.hasData)
                                                                                return const CircularProgressIndicator();

                                                                              List<DocumentSnapshot> documents = snapshot.data.documents;

                                                                              return documents.isEmpty
                                                                                  ? Container(
                                                                                      margin: EdgeInsets.only(top: 20),
                                                                                      child: Text(
                                                                                        'No tienes preguntas por el momento',
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    )
                                                                                  : ListView.builder(
                                                                                      shrinkWrap: true,
                                                                                      itemCount: documents.length,
                                                                                      itemBuilder: (BuildContext context, int index) {
                                                                                        PreguntaModel preguntaModel = PreguntaModel.fromDocumentSnapshot(documents[index]);

                                                                                        return GestureDetector(
                                                                                          onTap: () {
                                                                                            controller.preguntaModel = preguntaModel;
                                                                                            print(preguntaModel.pregunta);
                                                                                            preguntaModel.respuesta.isEmpty
                                                                                                ? showDialog(
                                                                                                    context: context,
                                                                                                    child: SimpleDialog(
                                                                                                      backgroundColor: Colors.white,
                                                                                                      contentPadding: EdgeInsets.all(0),
                                                                                                      children: <Widget>[DialogRespuesta()],
                                                                                                    ))
                                                                                                : null;
                                                                                          },
                                                                                          child: ListTile(
                                                                                              title: Text(
                                                                                                preguntaModel.pregunta,
                                                                                                style: TextStyle(color: Colors.white),
                                                                                              ),
                                                                                              trailing: Icon(
                                                                                                preguntaModel.respuesta.isEmpty ? Icons.question_answer : Icons.check,
                                                                                                color: Colors.white,
                                                                                              )),
                                                                                        );
                                                                                      },
                                                                                    );
                                                                            }),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ));
                                                        },
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 4),
                                                        // padding: EdgeInsets.only(left: 10,top: 50,right: 10),
                                                        decoration: BoxDecoration(
                                                            color: yemahuevo,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),

                                                        height: 10,
                                                        width: 10,
                                                        alignment:
                                                            Alignment.topRight,
                                                      ),
                                                    ],
                                                  );
                                          }),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          child: WillPopScope(
                                            onWillPop: () async {
                                              return controller.loading
                                                  ? false
                                                  : true;
                                            },
                                            child: SimpleDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              children: <Widget>[
                                                DialogContent(
                                                  foto: 'portada',
                                                ),
                                              ],
                                            ),
                                          ),
                                          context: context,
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 8,top: 15),
                                        alignment: Alignment.topRight,
                                        child: Column(
                                          children: [
                                           
                                            CircleAvatar(
                                              backgroundColor: pDark,
                                              radius: 17,
                                              child: Icon(
                                                Icons.photo_camera,
                                                size: 17,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      
                                      padding: EdgeInsets.only(top:15),
                                      child: IconButton(
                                        
                                       iconSize: 30,
                                          icon: Icon(
                                            
                                            Icons.directions_run,
                                            color: sLight,
                                          ),
                                          onPressed: () async {
                                           await controller.signOut();
                                             Navigator.of(context).pushNamedAndRemoveUntil(
                            '/', ModalRoute.withName('/'));
                                          }),
                                    ),
                                  ],
                                )
                              : Container(
                                  alignment: Alignment.topRight,
                                  padding: EdgeInsets.only(top: 20, right: 15),
                                  child: RaisedButton(
                                    padding: EdgeInsets.all(4),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: pDark),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    color: pDark,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Pregúntame ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                        Icon(
                                          Icons.tag_faces,
                                          size: 15,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        child: SimpleDialog(
                                          backgroundColor: Colors.white,
                                          contentPadding: EdgeInsets.all(0),
                                          children: <Widget>[
                                            HazPregunta(
                                              usuario: usuario,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        color: Colors.black38,
                        child: Column(
                          children: [
                            Text('Amigos',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            StreamBuilder(
                              stream: Firestore.instance
                                  .collection('usuarios')
                                  .where('amigos',
                                      arrayContains: usuario.documentId)
                                  .orderBy('nombre')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return Container(
                                      height: 50,
                                      child: const CircularProgressIndicator());

                                List<DocumentSnapshot> documents =
                                    snapshot.data.documents;

                                return documents.isEmpty
                                    ? Text(usuario.documentId ==
                                            controller.usuario.documentId
                                        ? 'No tienes amigos :C'
                                        : 'Usuario nuevo')
                                    : Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: ListView.builder(
                                                physics:
                                                    ClampingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: documents.length,
                                                itemBuilder: (context, index) {
                                                  UsuarioModel usuario =
                                                      UsuarioModel
                                                          .fromDocumentSnapshot(
                                                              documents[index]);

                                                  return AvatarAmigo(
                                                      usuario: usuario);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                              },
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Colors.white),
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  '|',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' Preguntas Anónimas ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '|',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            StreamBuilder(
                                stream: usuario.reference
                                    .collection(
                                      'preguntas',
                                    )
                                    .where('respuesta')
                                    .orderBy('fecha')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return const CircularProgressIndicator();

                                  List<DocumentSnapshot> documents =
                                      snapshot.data.documents;

                                  return documents.isEmpty
                                      ? Container(
                                          margin: EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Este usuario no tiene preguntas por el momento',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        )
                                      : Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: ListView.builder(
                                                physics:
                                                    ClampingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: documents.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  PreguntaModel preguntaModel =
                                                      PreguntaModel
                                                          .fromDocumentSnapshot(
                                                              documents[index]);

                                                  return preguntaModel
                                                          .respuesta.isNotEmpty
                                                      ? Column(
                                                          children: <Widget>[
                                                            ListTile(
                                                              title: Text(
                                                                preguntaModel
                                                                    .pregunta,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              subtitle: Text(
                                                                  preguntaModel
                                                                      .respuesta),
                                                              // trailing: Icon(
                                                              //   preguntaModel.respuesta.isEmpty
                                                              //       ? Icons.question_answer
                                                              //       : Icons.check,
                                                              //   color: Colors.white,
                                                              // )
                                                            ),
                                                          ],
                                                        )
                                                      : Container();
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                }),
                          ],
                        ),
                      ),
                      // Container(
                      //   height: 300,
                      //   color: Colors.white60,
                      // )
                    ],
                  ),
                );
              }),
        ));
  }
}

class DialogRespuesta extends StatefulWidget {
  PreguntaModel preguntaModel;
  DialogRespuesta({this.preguntaModel});
  @override
  _DialogRespuestaState createState() => _DialogRespuestaState();
}

class _DialogRespuestaState extends State<DialogRespuesta> {
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    TextEditingController textEditingController = TextEditingController();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                controller.preguntaModel.pregunta,
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                maxLength: 50,
                style: TextStyle(color: Colors.black),
                controller: textEditingController,
                decoration: InputDecoration(
                    labelText: 'Escribe una respuesta...',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 13)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        controller.loading2
            ? CircularProgressIndicator()
            : Container(
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: FlatButton(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Responder',
                        style: TextStyle(color: Colors.black),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 15,
                      )
                    ],
                  ),
                  onPressed: () async {
                    controller.loading2 = true;

                    controller.notify();

                    if (textEditingController.text.isEmpty ||
                        textEditingController.text.trim() == '') {
                      return;
                    }

                    // someMap['usuario']= controller.usuario.usuario;

                    // someMap['fecha']= DateTime.now();

                    // someMap['pregunta']= textEditingController.text;

                    await controller.preguntaModel.reference
                        .updateData({'respuesta': textEditingController.text});

                    //  widget.usuario.reference.collection('pregnutas').add(someMap);

                    // // controller.preguntas

                    //     .add(textEditingController.text);

                    textEditingController.clear();

                    controller.loading2 = false;

                    controller.notify();

                    Navigator.of(context).pop();
                  },
                ),
              )
      ],
    );
  }
}

class HazPregunta extends StatefulWidget {
  final UsuarioModel usuario;
  HazPregunta({this.usuario});
  @override
  _HazPreguntaState createState() => _HazPreguntaState();
}

class _HazPreguntaState extends State<HazPregunta> {
  Map<String, dynamic> someMap = {
    "usuario": '',
    "fecha": '',
    'pregunta': '',
    'respuesta': ''
  };

  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    TextEditingController textEditingController = TextEditingController();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Hazme una pregunta',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                controller: textEditingController,
                decoration: InputDecoration(
                    labelText: 'Escribe algo...',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        controller.loading2
            ? CircularProgressIndicator()
            : Container(
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: FlatButton(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Enviar',
                        style: TextStyle(color: Colors.black),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 15,
                      )
                    ],
                  ),
                  onPressed: () async {
                    if (textEditingController.text.isEmpty ||
                        textEditingController.text.trim() == '') {
                      return;
                    }
                    controller.loading2 = true;
                    controller.notify();
                    someMap['usuario'] = controller.usuario.usuario;
                    someMap['fecha'] = DateTime.now();
                    someMap['pregunta'] = textEditingController.text;

                    await widget.usuario.reference
                        .collection('preguntas')
                        .add(someMap);
                    // controller.preguntas
                    //     .add(textEditingController.text);
                    textEditingController.clear();
                    controller.loading2 = false;
                    controller.notify();
                    Navigator.of(context).pop();
                  },
                ),
              )
      ],
    );
  }
}

class DialogContent extends StatefulWidget {
  final String foto;

  const DialogContent({Key key, this.foto}) : super(key: key);
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
                    ? NetworkImage(widget.foto == 'perfil'
                        ? controller.usuario.foto
                        : controller.usuario.fotoPortada)
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
                        widget.foto == 'perfil'
                            ? FloatingActionButton.extended(
                                heroTag: 'perfil4',
                                onPressed: () async {
                                  controller.loading = true;
                                  controller.notify();

                                  final String fileName =
                                      controller.usuario.correo +
                                          '/perfil/' +
                                          DateTime.now().toString();

                                  StorageReference storageRef = FirebaseStorage
                                      .instance
                                      .ref()
                                      .child(fileName);

                                  final StorageUploadTask uploadTask =
                                      storageRef.putFile(
                                    imagen,
                                  );

                                  final StorageTaskSnapshot downloadUrl =
                                      (await uploadTask.onComplete);

                                  if (controller.usuario.fotoStorageRef !=
                                      null) {
                                    await FirebaseStorage.instance
                                        .ref()
                                        .child(
                                            (controller.usuario.fotoStorageRef))
                                        .delete()
                                        .catchError((onError) {
                                      print(onError);
                                    });
                                  }

                                  final String url =
                                      (await downloadUrl.ref.getDownloadURL());
                                  await controller.usuario.reference
                                      .updateData({
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
                            : FloatingActionButton.extended(
                                heroTag: 'perfil4',
                                onPressed: () async {
                                  controller.loading = true;
                                  controller.notify();

                                  final String fileName =
                                      controller.usuario.correo +
                                          '/portada/' +
                                          DateTime.now().toString();

                                  StorageReference storageRef = FirebaseStorage
                                      .instance
                                      .ref()
                                      .child(fileName);

                                  final StorageUploadTask uploadTask =
                                      storageRef.putFile(
                                    imagen,
                                  );

                                  final StorageTaskSnapshot downloadUrl =
                                      (await uploadTask.onComplete);

                                  if (controller.usuario.fotoStorageRef !=
                                      null) {
                                    await FirebaseStorage.instance
                                        .ref()
                                        .child((controller
                                            .usuario.fotoPortadaStorageRef))
                                        .delete()
                                        .catchError((onError) {
                                      print(onError);
                                    });
                                  }

                                  final String url =
                                      (await downloadUrl.ref.getDownloadURL());
                                  await controller.usuario.reference
                                      .updateData({
                                    'fotoPortada': url,
                                    'fotoPortadaStorageRef':
                                        downloadUrl.ref.path
                                  });

                                  controller.usuario.fotoPortada = url;
                                  controller.usuario.fotoPortadaStorageRef =
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
        .where('amigos', arrayContains: controller.usuario.documentId).orderBy('usuario', descending: true)
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

class AvatarAmigo extends StatelessWidget {
  const AvatarAmigo({
    Key key,
    @required this.usuario,
  }) : super(key: key);

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            return Navigator.of(context).push(MaterialPageRoute(builder: (context) => Perfil(usuario: usuario),),);
          },
          child: Container(
            height: 40,
            width: 40,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(usuario.foto),
            ),
          ),
        ),
      ],
    );
  }
}
