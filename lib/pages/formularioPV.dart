import 'package:flutter/material.dart';
import 'package:trivia_form/services/services.dart';
import 'package:trivia_form/shared/shareStuff.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormularioPV extends StatefulWidget {
  final FormularioModel formularioModel;
  FormularioPV({this.formularioModel});
  @override
  _FormularioPVState createState() => _FormularioPVState();
}

class _FormularioPVState extends State<FormularioPV> {
  FormularioModel formulario = FormularioModel();

  PageController pageController = PageController(
    initialPage: 0,
  );
  int index = 1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Controller controller = Provider.of(context);
    return WillPopScope(
      onWillPop: () async {
        controller.vRespuestas.clear();
        controller.respuestas.clear();
        controller.textECR.clear();
        return true;
      },
      child: Scaffold(
        appBar: myAppBar(controller, context),
        body: PageView(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: (value) {
            controller.textECR.text = controller.respuestas[value];
            index = value + 1;
            controller.notify();
          },
          children: pageBuilder(controller, context),
        ),
      ),
    );
  }

  List<Widget> pageBuilder(Controller controller, BuildContext context) {
    List<Widget> pages = [];
    widget.formularioModel.preguntas.forEach((pregunta) {
      if (controller.respuestas.length !=
          widget.formularioModel.preguntas.length) {
        controller.respuestas.add('');
      }

      pages.add(Container(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$index / ${widget.formularioModel.preguntas.length}'),
            Text(
              pregunta.pregunta,
              style: TextStyle(fontSize: 25),
            ),
            TextFormField(
              onChanged: (value) {
                controller.respuestas[index - 1] = controller.textECR.text;
                controller.notify();
              },
              controller: controller.textECR,
              decoration: InputDecoration(
                labelText: 'Respuesta',
              ),
              validator: (value) => validateAnswer(value),
              onSaved: (newValue) => saveAnswer(formulario, newValue, pregunta),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton.extended(
              heroTag: 'respuestas',
              icon: Icon(index == widget.formularioModel.preguntas.length
                  ? Icons.send
                  : Icons.skip_next),
              label: Text(index == widget.formularioModel.preguntas.length
                  ? 'Enviar Respuestas'
                  : 'Siguiente'),
              onPressed: () async {
                if (index == widget.formularioModel.preguntas.length) {
                  controller.vRespuestas.clear();
                  for (var respuesta in controller.respuestas) {
                    if (!validateAnswerBool(respuesta)) {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            title: Text(

                                'Debes de contestar todas las preguntas de la libreta. No se puede contestar no se, o algo parecido y las respuestas deben de tener mino 3 letras'),

                          ));
                      controller.vRespuestas.clear();
                      return;
                    }
                    controller.vRespuestas.add(Respuesta.fromString(
                        respuesta, controller.usuario.usuario));
                    print(respuesta);
                  }
                  print(controller.vRespuestas.length);
                  int tracker = 0;

                  for (var respuesta in controller.vRespuestas) {
                    controller.toFillForm.preguntas[tracker].respuestas
                        .add(respuesta.toMap());
                    tracker = tracker + 1;
                  }

                  controller.toFillForm.invitaciones
                      .remove(controller.usuario.usuario);
                  controller.toFillForm.usuarios
                      .add(controller.usuario.usuario);

                  List<Map<String, dynamic>> p = [];
                  controller.toFillForm.preguntas.forEach((pregunta) {
                    p.add(pregunta.toMap());
                  });

                  final DocumentReference postRef =
                      controller.toFillForm.reference;
                  Firestore.instance.runTransaction((Transaction tx) async {
                    DocumentSnapshot postSnapshot = await tx.get(postRef);
                    if (postSnapshot.exists) {
                      await tx.update(postRef, <String, dynamic>{
                        'preguntas': p,
                        'usuarios': controller.toFillForm.usuarios,
                        'invitaciones': controller.toFillForm.invitaciones,
                      });
                    }
                  });

                  controller.vRespuestas.clear();
                  controller.respuestas.clear();
                  controller.textECR.clear();

                  if (controller.usuario.dailyAnswers > 0) {
                    controller.usuario.dailyAnswers =
                        controller.usuario.dailyAnswers - 1;
                    controller.loading = true;
                    controller.notify();
                    showDialog(
                      context: context,
                      child: WillPopScope(
                        onWillPop: () async {
                          return false;
                        },
                        child: CoinRewardDialog(),
                      ),
                    );
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home', ModalRoute.withName('/'));
                    print('Todo bien');

                    return;
                  }
                } else {
                  if (pageController.page != 0) {
                    if (!validateAnswerBool(controller.textECR.text)) {
                      print('D:');
                      showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Text('Respuesta muy corta'),
                          content: Text('Necesitas detallar mas tu respuesta'),
                        ),
                      );
                      return;
                    }
                    pageController.nextPage(
                        duration: Duration(seconds: 1),
                        curve: ElasticInCurve());

                    setState(() {});
                  } else {
                    if (!validateAnswerBool(controller.textECR.text)) {
                      print('D:');
                      showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Text('Respuesta muy corta'),
                          content: Text('Necesitas detallar mas tu respuesta'),
                        ),
                      );
                      return;
                    }
                    pageController.jumpToPage(1);

                    setState(() {});
                  }
                }
                // pageController.animateToPage(1,
                //     duration: Duration(seconds: 1), curve: ElasticInCurve());
                // pageController.previousPage(duration: Duration(seconds: 1), curve: ElasticInCurve());
              },
            )
          ],
        ),
      ));
    });

    return pages;
  }

  saveAnswer(FormularioModel formulario, String newValue, Pregunta pregunta) {
    pregunta.respuestas.add(
      {
        'respuesta': newValue,
        'usuario': 'Memo god',
        'fecha': DateTime.now(),
      },
    );
  }

  bool validateAnswerBool(String value) {
    if (value.isEmpty ||
        value.trim() == '' ||
        value.trim().toLowerCase() == 'nose' ||
        value.trim().toLowerCase() == 'no se' ||
        value.trim().length < 3) {
      return false;
    }
    return true;
  }

  String validateAnswer(String value) {
    if (value.isEmpty ||
        value.trim() == '' ||
        value.trim().toLowerCase() == 'nose' ||
        value.trim().toLowerCase() == 'no se') {
      return 'Debes de contestar la pregunta';
    }
    return null;
  }
}

class CoinRewardDialog extends StatelessWidget {
  const CoinRewardDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return AlertDialog(
      title: Text(
        '¡Felicidades!',
        style: TextStyle(fontSize: 30),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.stars,
                color: Colors.yellow[800],
              ),
              Expanded(
                child: Text(
                  'Haz ganado una recompensa de 5 Monedas por contestar esta Libreta',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
              'Te quedan ${controller.usuario.dailyAnswers} de 3 oportunidades para recibir mas monedas'),
        ],
      ),
      actions: <Widget>[
        RaisedButton(
          child: Row(
            children: <Widget>[Text('Continuar')],
          ),
          onPressed: () async {
            controller.usuario.coins = controller.usuario.coins + 5;
            await controller.usuario.reference.updateData({
              'dailyAnswers': controller.usuario.dailyAnswers,
              'coins': controller.usuario.coins
            });
            controller.loading = false;
            controller.notify();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/home', ModalRoute.withName('/'));
          },
        )
      ],
    );
  }
}
