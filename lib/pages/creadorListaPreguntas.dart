import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/services/services.dart';
import 'package:trivia_form/shared/colors.dart';

class CreadorLP extends StatefulWidget {
  @override
  _CreadorLPState createState() => _CreadorLPState();
}

class _CreadorLPState extends State<CreadorLP> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'PREGUNTAS (${controller.preguntas.length}/15)',
              style: TextStyle(fontSize: 20),
            ),
            Text('Nota: Minimo debes de poner 3 preguntas'),
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
                    icon: Icon(Icons.delete,color: pDark,),
                  ),
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                FloatingActionButton(
                  heroTag: 'btn1',
                  mini: true,
                  child: Icon(Icons.add),
                  onPressed: () {
                    if (controller.preguntas.length >= 15) {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            title: Text('No puedes tener más de 15 preguntas'),
                            
                          ));
                      return;
                    }
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
                                style: TextStyle(color: Colors.white),
                                controller: textEditingController,
                                decoration: InputDecoration(
                                  labelText: 'Escribe la pregunta',
                                  labelStyle: TextStyle(color: Colors.white)
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              FloatingActionButton.extended(
                                heroTag: 'btn2',
                                icon: Icon(Icons.add),
                                label: Text('Agregar Pregunta'),
                                onPressed: () {
                                  if (textEditingController.text.isEmpty ||
                                      textEditingController.text.trim() == '') {
                                    return;
                                  }

                                  controller.preguntas
                                      .add(textEditingController.text);
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
                  heroTag: 'btn3',
                  onPressed: () {
                    controller.pageController.jumpToPage(0);
                    
                  },
                  label: Text('Back'),
                ),
                FloatingActionButton.extended(
                  heroTag: 'btn4',
                  onPressed: () {
                    if(controller.preguntas.length < 3){
                       showDialog(
                          context: context,
                          child: AlertDialog(
                            title: Text('No puedes tener menos de 3 preguntas'),
                            
                          ));
                      return;
                    }
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
