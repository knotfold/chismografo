import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ChisMe/services/services.dart';
import 'package:provider/provider.dart';
import 'package:ChisMe/shared/shared.dart';
import 'package:ChisMe/pages/pages.dart';

class LibretaDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of(context);
    List<Pregunta> preguntas = controller.toFillForm.preguntas;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        actionsIconTheme: IconThemeData(color: primaryColor),
        title: Text(
          'Preguntas',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.chat),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Chat(
                        usuarios: controller.toFillForm.usuarios,
                        groupID: controller.toFillForm.reference.documentID,
                        nombre: controller.toFillForm.nombre,
                        foto: controller.toFillForm.imagen,
                        group: true,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.stars),
                color: Colors.yellow[800],
                onPressed: () {
                  controller.seleccionado = 4;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home', ModalRoute.withName('/'));
                },
              ),
              Text(
                controller.usuario.coins.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
              SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      child: Dialog(
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Usuarios',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              controller.toFillForm.usuarios.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        'No hay usuarios participando',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          controller.toFillForm.usuarios.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Text(
                                          '-' +
                                              controller
                                                  .toFillForm.usuarios[index],
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        );
                                      },
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Invitados',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              controller.toFillForm.invitaciones.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        'No hay usuarios invitados',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: controller
                                          .toFillForm.invitaciones.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '-' +
                                                  controller.toFillForm
                                                      .invitaciones[index],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                              controller.usuario.usuario !=
                                          controller
                                              .toFillForm.creadorUsuario &&
                                      controller.toFillForm.priv
                                  ? Container()
                                  : controller.usuario.usuario ==
                                              controller
                                                  .toFillForm.creadorUsuario ||
                                          !controller.toFillForm.priv
                                      ? FloatingActionButton.extended(
                                          heroTag: 'invamigos',
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                child: Dialog(
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child: AmigosSelec()),
                                                ));
                                          },
                                          label: Text('Invitar Amigos'),
                                          icon: Icon(Icons.group_add),
                                        )
                                      : Container(),
                            ],
                          ),
                        ),
                      ));
                },
                icon: Icon(Icons.people),
              ),
              Text(
                controller.toFillForm.usuarios.length.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
        ],
      ),
      body: controller.toFillForm.usuarios.length < 3
          ? Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'No puedes ver las respuestas de esta libreta hasta que 3 personas la hayan contestado',
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      color: backgroundColor,
                      highlightColor: backgroundColor,
                      icon: Icon(Icons.group_add),
                      onPressed: () {
                        showDialog(
                            context: context,
                            child: Dialog(
                              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Usuarios',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    controller.toFillForm.usuarios.isEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              'No hay usuarios participando',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: controller
                                                .toFillForm.usuarios.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Text(
                                                '-' +
                                                    controller.toFillForm
                                                        .usuarios[index],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              );
                                            },
                                          ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Invitados',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    controller.toFillForm.invitaciones.isEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              'No hay usuarios invitados',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: controller
                                                .toFillForm.invitaciones.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(height: 10),
                                                  Text(
                                                    '-' +
                                                        controller.toFillForm
                                                                .invitaciones[
                                                            index],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(height: 10),
                                                ],
                                              );
                                            },
                                          ),
                                    controller.usuario.usuario !=
                                                controller.toFillForm
                                                    .creadorUsuario &&
                                            controller.toFillForm.priv
                                        ? Container()
                                        : controller.usuario.usuario ==
                                                    controller.toFillForm
                                                        .creadorUsuario ||
                                                !controller.toFillForm.priv
                                            ? FloatingActionButton.extended(
                                                heroTag: 'invamigos',
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      child: Dialog(
                                                        child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20),
                                                            child:
                                                                AmigosSelec()),
                                                      ));
                                                },
                                                label: Text('Invitar Amigos'),
                                                icon: Icon(Icons.group_add),
                                              )
                                            : Container(),
                                  ],
                                ),
                              ),
                            ));
                      },
                    )
                  ],
                ),
              ),
            )
          : Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Text(
                    //   'Preguntas',
                    //   style: TextStyle(fontSize: 25),
                    // ),
                    Text(
                      controller.toFillForm.nombre,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        height: 2,
                        thickness: 1.5,
                        color: Colors.white,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: preguntas.length,
                      itemBuilder: (context, index) => Card(
                        elevation: 1,
                        color: Colors.white,
                        child: ListTile(
                          onTap: () {
                            List<dynamic> respuestas =
                                preguntas[index].respuestas;
                            respuestas.shuffle();
                            showDialog(
                                context: context,
                                child: RespuestasDialog(
                                  preguntas: preguntas,
                                  respuestas: respuestas,
                                  controller: controller,
                                  index: index,
                                  formularioModel: controller.toFillForm,
                                ));
                          },
                          leading: Text(
                            (index + 1).toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          title: Text(
                            preguntas[index].pregunta,
                          ),
                          trailing: Icon(
                            Icons.remove_red_eye,
                            color: pDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class RespuestasDialog extends StatefulWidget {
  const RespuestasDialog(
      {Key key,
      @required this.preguntas,
      @required this.respuestas,
      @required this.controller,
      @required this.index,
      @required this.formularioModel})
      : super(key: key);

  final List<Pregunta> preguntas;
  final List respuestas;
  final Controller controller;
  final int index;
  final FormularioModel formularioModel;

  @override
  _RespuestasDialogState createState() => _RespuestasDialogState();
}

class _RespuestasDialogState extends State<RespuestasDialog> {
  bool isLiked(Respuesta respuesta, Controller controller) {
    bool liked = false;

    if (respuesta.likes.isEmpty) {
      return false;
    }

    respuesta.likes.forEach((element) {
      if (element == controller.usuario.usuario) {
        liked = true;
        return;
      }
    });

    return liked;
  }

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.preguntas[widget.index].pregunta,
                style: TextStyle(
                  color: sDark,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
              Divider(
                height: 20,
                color: Colors.white54,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, ind) {
                  Respuesta respuesta =
                      Respuesta.fromMap(widget.respuestas[ind]);
                  return ListTile(
                    contentPadding: EdgeInsets.all(10),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(widget.respuestas[ind]['likes'] == null
                            ? '0'
                            : widget.respuestas[ind]['likes'].length
                                .toString()),
                        IconButton(
                          color: isLiked(respuesta, widget.controller)
                              ? secondaryColor
                              : Colors.grey,
                          icon: Icon(Icons.thumb_up),
                          onPressed: () async {
                            if(controller.loading){
                              return;
                            }

                            controller.loading = true;
                            
                            await Firestore.instance
                                .runTransaction((Transaction tx) async {
                              DocumentSnapshot postSnapshot = await tx
                                  .get(widget.formularioModel.reference);
                              if (postSnapshot.exists) {
                                widget.controller.toFillForm =
                                    FormularioModel.fromDS(postSnapshot);

                                Pregunta pregunta = widget.controller.toFillForm
                                    .preguntas[widget.index];

                                Respuesta respuesta =
                                    Respuesta.fromMap(widget.respuestas[ind]);

                                if (isLiked(respuesta, widget.controller)) {
                                  respuesta.likes.remove(
                                      widget.controller.usuarioAct.usuario);
                                } else {
                                  respuesta.likes.add(
                                      widget.controller.usuarioAct.usuario);
                                }

                                var trueRespuesta = pregunta.respuestas
                                    .indexWhere((element) =>
                                        element['usuario'] ==
                                        respuesta.usuario);

                                pregunta.respuestas[trueRespuesta] =
                                    respuesta.toMap();

                                widget.respuestas[ind] = respuesta.toMap();

                                widget.controller.toFillForm
                                    .preguntas[widget.index] = pregunta;

                                await tx.update(
                                    widget.formularioModel.reference,
                                    widget.controller.toFillForm.toMap());
                              }
                            });
                            controller.loading = false;
                            widget.controller.notify();
                            setState(() {});
                          },
                        ),
                        IconButton(
                          color: sDark,
                          icon: Icon(Icons.lock_open),
                          onPressed: () {
                            showDialog(
                              context: context,
                              child: DesbloquearDialog(
                                controller: widget.controller,
                                usuario: widget.respuestas[ind]['usuario'],
                                respuesta: widget.respuestas[ind]['respuesta'],
                                pregunta:
                                    widget.preguntas[widget.index].pregunta,
                                preg: false,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    title: Text(
                      widget.respuestas[ind]['respuesta'],
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                },
                itemCount: widget.respuestas.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DesbloquearDialog extends StatefulWidget {
  DesbloquearDialog(
      {Key key,
      @required this.controller,
      this.pregunta,
      this.respuesta,
      this.usuario,
      this.preg})
      : super(key: key);

  final Controller controller;
  final String usuario;
  final String respuesta;
  final String pregunta;
  final bool preg;
  final List<String> textosRespuesta = [
    'Disfruta la verdad :)',
    'A veces es mejor no saber todo',
    '¿Por qué no mantenerlo en secreto?',
    'La verdad en ocaciones no es lo mejor',
    'Esto será un secreto entre nosotros ;)',
    '¿Ésta era la persona que esperabas?',
    'La curiosidad mató al gato',
    '¿No era lo que esperabas?',
    '¿Estás satisfecho?',
    'Sustos que dan gusto'
  ];

  @override
  _DesbloquearDialogState createState() => _DesbloquearDialogState();
}

class _DesbloquearDialogState extends State<DesbloquearDialog> {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Desbloquear respuesta',
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
          'Para saber quien escribió esta respuesta necesitas pagar  5 monedas'),
      actions: widget.controller.loading
          ? <Widget>[
              LinearProgressIndicator(
                backgroundColor: secondaryColor,
              )
            ]
          : <Widget>[
              FlatButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: buttonColors),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              RaisedButton(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: buttonColors,
                onPressed: () async {
                  controller.loading = true;
                  controller.notify();
                  var _random = new Random();
                  var randonText = widget.textosRespuesta[
                      _random.nextInt(widget.textosRespuesta.length)];
                  //(widget.textos.toList()..shuffle()).first;
                  var status = await widget.controller.gastarMonedas();
                  if (status) {
                    controller.loading = false;
                    await showDialog(
                      context: context,
                      child: AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(
                          randonText,
                          style: GoogleFonts.courgette(
                              fontSize: 25, color: secondaryColor),
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // Divider(
                            //   thickness: 1,
                            //   height: 0,
                            //   color: sDark,
                            // ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              '${widget.pregunta}:',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.black),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    ' ${widget.respuesta}',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 15),
                            //  Divider(
                            //   thickness: 1,
                            //   height: 0,
                            //   color: sDark,
                            // ),
                            // SizedBox(height:15),
                            Container(
                              width: double.maxFinite,
                              alignment: Alignment.bottomRight,
                              child: Text(
                                ' Por: ${widget.usuario}',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          // RaisedButton(
                          //     color: pDark,
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(20),side: BorderSide(color: secondaryColor)),
                          //   onPressed: () => Navigator.of(context).pop(),
                          //   child: Text(
                          //     'Aceptar',
                          //     style: TextStyle(color: secondaryColor),
                          //   ),
                          // )
                        ],
                      ),
                    );
                  } else {
                    controller.loading = false;
                    await showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text(
                          '¡No tienes suficientes monedas!',
                          style: TextStyle(fontSize: 30),
                        ),
                        content: Text(
                            '¡Para ver quien escribio esta respuesta debes de utilizar 5 monedas y solo tienes ${widget.controller.usuario.coins}!'),
                        actions: <Widget>[
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.white,
                            child: Text('Cancelar',
                                style: TextStyle(
                                  color: pDark,
                                )),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          RaisedButton(
                            elevation: 10,
                            color: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              widget.controller.seleccionado = 4;
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/home', ModalRoute.withName('/'));
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.store,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Ir a la tienda',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.lock_open,
                      color: Colors.white,
                    ),
                    Text(
                      'Desbloquear',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
    );
  }
}
