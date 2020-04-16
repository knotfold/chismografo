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
        actions: <Widget>[
          Text(controller.toFillForm.usuarios.length.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                child: Dialog(
                  backgroundColor: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Usuarios', style: TextStyle(fontSize: 20),),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.toFillForm.usuarios.length,
                          itemBuilder: (BuildContext context, int index) {
                          return Text( '-'+controller.toFillForm.usuarios[index],);
                         },
                        ),
                      ],
                    ),
                  ),
                )
              );
            },
            icon: Icon(Icons.people),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: controller.toFillForm.usuarios.length < 1
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
                        )
                        : !controller.toFillForm.priv
                            ? IconButton(
                              color: backgroundColor,
                              icon: Icon(Icons.group_add),
                            )
                            : Container(),
                  ],
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Preguntas',
                    style: TextStyle(fontSize: 25),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: preguntas.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            child: Dialog(
                              child: Container(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      preguntas[index].pregunta,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (context, ind) {
                                        return Text('-' + preguntas[index]
                                            .respuestas[ind]['respuesta']);
                                      },
                                      itemCount:
                                          preguntas[index].respuestas.length,
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },
                      leading: Text((index + 1).toString()),
                      title: Text(preguntas[index].pregunta),
                      trailing: Icon(Icons.details),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
