import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/services/services.dart';

class CreadorLP extends StatefulWidget {
  @override
  _CreadorLPState createState() => _CreadorLPState();
}

class _CreadorLPState extends State<CreadorLP> {
  TextEditingController textEditingController = TextEditingController();
  List<String> preguntas = [];

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('PREGUNTAS', style: TextStyle(fontSize: 20),),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.preguntas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(controller.preguntas[index]),
                  leading: Text((index + 1).toString()),
                  trailing: IconButton(
                    onPressed: () {
                      controller.preguntas.remove(controller.preguntas[index]);
                    controller.notify();
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            ),
            SizedBox(height: 10,),
            Row(
              children: <Widget>[
                FloatingActionButton(
                  mini: true,
                  child: Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      child: Dialog(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TextField(
                                controller: textEditingController,
                                decoration: InputDecoration(
                                  labelText: 'Nueva Pregunta',
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              FloatingActionButton.extended(
                                icon: Icon(Icons.add),
                                label: Text('Agregar Nueva Pregunta'),
                                onPressed: () {
                                  if (textEditingController.text.isEmpty ||
                                      textEditingController.text.trim() == '') {
                                    return;
                                  }

                                  controller.preguntas.add(textEditingController.text);
                                  textEditingController.clear();
                                  controller.notify();

                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                    setState(() {});
                  },
                ),
                 FloatingActionButton.extended(
                                onPressed: () {
                                  controller.pageController.jumpToPage(0);
                                },
                                label: Text('Back'),
                              ),
                  FloatingActionButton.extended(
                                onPressed: () {
                                  controller.pageController.jumpToPage(2);
                                },
                                label: Text('Next'),
                              ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
