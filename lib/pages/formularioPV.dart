import 'package:flutter/material.dart';
import 'package:trivia_form/services/services.dart';
import 'package:trivia_form/shared/shareStuff.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
      appBar: myAppBar(),
      body: PageView(
        scrollDirection: Axis.horizontal,
        physics: PageScrollPhysics(),
        controller: pageController,
        onPageChanged: (value) {
          controller.textECR.text = controller.respuestas[value];
          index = value + 1;
          controller.notify();
        },
        children: pageBuilder(controller, context),
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

      print(pregunta.pregunta);
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
                print(controller.respuestas.length);
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
                                'Debes de contestar todas las preguntas de la libreta. No se puede contestar no se, o algo parecido y las respuestas deben de tener mino 5 letras'),
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
                    print(tracker);
                    print(controller.toFillForm.preguntas[tracker].pregunta);
                    controller.toFillForm.preguntas[tracker].respuestas
                        .add(respuesta.toMap());
                    tracker = tracker + 1;
                  }

                  controller.toFillForm.invitaciones
                      .remove(controller.usuario.documentId);
                  controller.toFillForm.usuarios
                      .add(controller.usuario.usuario);

                  await controller.toFillForm.reference
                      .updateData(controller.toFillForm.toMap());

                  controller.vRespuestas.clear();
                  controller.respuestas.clear();
                  controller.textECR.clear();

                  Navigator.of(context).pushReplacementNamed('/home');

                  print('Todo bien');

                  return;
                }
                if (pageController.page != 0) {
                  pageController.nextPage(
                      duration: Duration(seconds: 1), curve: ElasticInCurve());

                  setState(() {});
                } else {
                  pageController.jumpToPage(1);

                  setState(() {});
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
        value.length < 5) {
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
