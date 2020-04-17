import 'package:flutter/material.dart';
import 'package:trivia_form/services/services.dart';
import 'package:trivia_form/shared/shareStuff.dart';

class Formulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FormularioModel formulario = FormularioModel();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        child: Icon(Icons.save),
      ),
      appBar: myAppBar(),
      body: ListView.builder(
        itemCount: formulario.preguntas.length,
        itemBuilder: (context, index) => Container(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(formulario.preguntas[index].pregunta),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Respuesta',
                  ),
                  validator: (value) => validateAnswer(value),
                  onSaved: (newValue) => saveAnswer(index, formulario, newValue),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  saveAnswer(int index, FormularioModel formulario, String newValue) {
    formulario.preguntas[index].respuestas.add(
      {
        'respuesta': newValue,
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
