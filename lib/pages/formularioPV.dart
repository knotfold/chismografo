import 'package:flutter/material.dart';
import 'package:trivia_form/services/services.dart';
import 'package:trivia_form/shared/shareStuff.dart';

class FormularioPV extends StatefulWidget {
  @override
  _FormularioPVState createState() => _FormularioPVState();
}

class _FormularioPVState extends State<FormularioPV> {
  Formulario1 formulario1 = Formulario1();
  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: myAppBar(),
      body: PageView(
        scrollDirection: Axis.horizontal,
        physics: PageScrollPhysics(),
        controller: pageController,
        onPageChanged: (value) => null,
        children: pageBuilder(),
      ),
    );
  }

  List<Widget> pageBuilder() {
    TextEditingController textEditingController = TextEditingController();
    List<Widget> pages = [];
    formulario1.preguntas.forEach((pregunta) {
      pages.add(Container(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              pregunta.pregunta,
              style: TextStyle(fontSize: 25),
            ),
            TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                labelText: 'Respuesta',
              ),
              validator: (value) => validateAnswer(value),
              onSaved: (newValue) =>
                  saveAnswer(formulario1, newValue, pregunta),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton.extended(
              icon: Icon(Icons.skip_next),
              label: Text('Siguiente'),
              onPressed: () {
                if (textEditingController.text.trim() == '' ||
                    textEditingController.text.isEmpty ||
                    textEditingController.text.trim().toLowerCase() == 'nose' ||
                    textEditingController.text.trim().toLowerCase() ==
                        'no se') {
                  print('bad answer');
                  return;
                }
                textEditingController.clear();
                if (pageController.page != 0) {
                  pageController.nextPage(
                      duration: Duration(seconds: 1), curve: ElasticInCurve());
                } else {
                  pageController.jumpToPage(1);
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

  saveAnswer(Formulario1 formulario1, String newValue, Pregunta pregunta) {
    pregunta.respuestas.add(
      {
        'respuesta': newValue,
        'usuarioNombre': 'Memo god',
        'usuarioFoto':
            'https://scontent-ssn1-1.xx.fbcdn.net/v/t1.0-9/90590478_3194401850588829_8179029891061121024_o.jpg?_nc_cat=111&_nc_sid=85a577&_nc_ohc=Ds1ApjyXdy8AX8gQWIP&_nc_ht=scontent-ssn1-1.xx&oh=5e2f518ff1449c1bc8f0f3894e32a39a&oe=5EBB0839',
      },
    );
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
