import 'dart:html';

import 'package:flutter/material.dart';
import 'package:trivia_form/services/services.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/shared/shared.dart';

class LibretaDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of(context);
    List<Pregunta> preguntas = controller.toFillForm.preguntas;
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Preguntas',style: TextStyle(color: Colors.white),),
       backgroundColor: buttonColors,
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
            icon: Icon(Icons.stars),
            color: Colors.yellow[800],
            onPressed: () {
              controller.seleccionado = 4;
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/home', ModalRoute.withName('/'));
            },
          ),
              Text(
                controller.usuario.coins.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
              ),
                SizedBox(width: 10),
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  child: Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    backgroundColor: backgroundColor,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Usuarios',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          controller.toFillForm.usuarios.isEmpty
                              ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('No hay usuarios participando'),
                              )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      controller.toFillForm.usuarios.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Text(
                                      '-' +
                                          controller.toFillForm.usuarios[index],
                                          style: TextStyle(fontSize: 15),
                                    );
                                  },
                                ),
                          Text(
                            'Invitados',
                            style: TextStyle(fontSize: 20),
                          ),
                         
                          controller.toFillForm.invitaciones.isEmpty
                              ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('No hay usuarios invitados'),
                              )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      controller.toFillForm.invitaciones.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Text(
                                      '-' +
                                          controller
                                              .toFillForm.invitaciones[index],
                                    );
                                  },
                                ),
                          controller.usuario.usuario ==
                                      controller.toFillForm.creadorUsuario ||
                                  controller.toFillForm.priv
                              ? FloatingActionButton.extended(
                                heroTag: 'invamigos',
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        child: Dialog(
                                          child: Container(
                                              padding: EdgeInsets.all(20),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
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
                    controller.toFillForm.priv &&
                            controller.usuario.documentId ==
                                controller.toFillForm.creadorID
                        ? IconButton(
                            color: backgroundColor,
                            highlightColor: backgroundColor,
                            icon: Icon(Icons.group_add),
                            onPressed: () {},
                          )
                        : !controller.toFillForm.priv
                            ? IconButton(
                                color: backgroundColor,
                                icon: Icon(Icons.group_add),
                                onPressed: () {},
                              )
                            : Container(),
                  ],
                ),
              ),
            )
          : Container(
            
              padding: EdgeInsets.only(left: 15,right: 15,bottom: 15,top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Text(
                  //   'Preguntas',
                  //   style: TextStyle(fontSize: 25),
                  // ),
                  
                  ListView.separated(
                    separatorBuilder: (context,index)=>Divider(height: 2,thickness: 1.5,color: Colors.brown[100],),
                    shrinkWrap: true,
                    itemCount: preguntas.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        List<dynamic> respuestas = preguntas[index].respuestas;
                        respuestas.shuffle();
                        showDialog(
                            context: context,
                            child: Dialog(
                              backgroundColor: backgroundColor,
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: <Widget>[
                                      

                                     ],
                                   ),
                                    Text(
                                      preguntas[index].pregunta,
                                      style: TextStyle(fontSize: 25),
                                      textAlign: TextAlign.center,
                                    ),
                                    
                                     Divider(height: 30,color: Colors.white54,),
                                     
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (context, ind) {
                                        return ListTile(
                                          trailing: IconButton(
                                            icon: Icon(Icons.lock_open),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                child: DesbloquearDialog(
                                                  controller: controller,
                                                  respuestas: respuestas,
                                                  usuario: respuestas[ind]
                                                      ['usuario'],
                                                  respuesta: respuestas[ind]
                                                      ['respuesta'],
                                                  pregunta:
                                                      preguntas[index].pregunta,
                                                ),
                                              );
                                            },
                                          ),
                                          title: Text(
                                              respuestas[ind]['respuesta']),
                                        );
                                      },
                                      itemCount: respuestas.length,
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },

                      leading: Text((index + 1).toString(),style: TextStyle(fontSize: 20),),

                      title: Text(preguntas[index].pregunta),
                      trailing: Icon(Icons.library_books),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class DesbloquearDialog extends StatefulWidget {
  const DesbloquearDialog(
      {Key key,
      @required this.controller,
      @required this.respuestas,
      this.pregunta,
      this.respuesta,
      this.usuario})
      : super(key: key);

  final Controller controller;
  final List respuestas;
  final String usuario;
  final String respuesta;
  final String pregunta;

  @override
  _DesbloquearDialogState createState() => _DesbloquearDialogState();
}

class _DesbloquearDialogState extends State<DesbloquearDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Desbloquer respuesta'),
      content: Text(
          'Para saber quien escribió esta respuesta necesitas pagar 5 monedas'),
      actions: widget.controller.loading
          ? <Widget>[LinearProgressIndicator()]
          : <Widget>[
              FlatButton(
                color: Colors.white,
                
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar',style: TextStyle(color: buttonColors),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              RaisedButton(
                color: buttonColors,
                onPressed: () async {
                  var status = await widget.controller.gastarMonedas();
                  if (status) {
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Text('Disfruta de la verdad :)'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                '${widget.pregunta}',
                                style: TextStyle(fontSize: 30),
                              ),
                              Text(
                                '${widget.usuario} :',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text('${widget.respuesta}'),
                            ],
                          ),
                          actions: <Widget>[
                            RaisedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Aceptar',style: TextStyle(color: Colors.white),),
                            )
                          ],
                        ));
                  } else {
                    showDialog(
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
                              child: Text('Cancelar'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            RaisedButton(
                              onPressed: () {
                                widget.controller.seleccionado = 4;
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/home', ModalRoute.withName('/'));
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.store),
                                  Text('Ir a la tienda'),
                                ],
                              ),
                            )
                          ],
                        ));
                  }
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.lock_open,color: Colors.white,),
                    Text('Desbloquear',style: TextStyle(color: Colors.white),),
                  ],
                ),
              )
            ],
    );
  }
}
