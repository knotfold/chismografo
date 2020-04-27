import 'package:flutter/material.dart';
import 'pages.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/services/services.dart';

class FormularioCreator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
       backgroundColor: Colors.transparent,
      ),
      body: PageView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: controller.pageController,
        children: <Widget>[
          first(controller),
          CreadorLP(),
          AmigosSelector()
        ],
      ),
    );
  }

  Widget first(Controller controller) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'NOMBRE DE TU LIBRETA',
            style: TextStyle(fontSize: 20),
          ),
          TextFormField(
            controller: controller.textEditingController,
            decoration: InputDecoration(
              labelText: 'Nombre',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text('Privacidad'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Solo Amigos', style: TextStyle(color: controller.privado ? null : Colors.grey),),
              Switch(
                value: controller.privado,
                onChanged: (value){
                  controller.privado = value;
                  controller.notify();
                },
              ),
              Column(children: <Widget>[
                 Text('Amigos y Amigos', style: TextStyle(color: controller.privado ? Colors.grey : null),),
                  Text('de mis Amigos', style: TextStyle(color: controller.privado ? Colors.grey : null),),
              ],),
             
            ],
          ),
          FloatingActionButton.extended(
            heroTag: 'btnT1',
            onPressed: () {
              controller.pageController.jumpToPage(1);
            },
           
            label: Text('Siguiente'),
          ),
        ],
      ),
    );
  }
}
