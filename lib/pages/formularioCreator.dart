import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ChisMe/services/services.dart';
import 'package:ChisMe/pages/pages.dart';
import 'package:ChisMe/shared/colors.dart';

class FormularioCreator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of(context);
    return WillPopScope(
      onWillPop: () async {
        return controller.loading ? false : true;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: pDark),
          elevation: 1,
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          controller: controller.pageController,
          children: <Widget>[
            first(controller, context),
            CreadorLP(),
            AmigosSelector()
          ],
        ),
      ),
    );
  }

  Widget first(Controller controller, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'FOTO DE TU LIBRETA',
              style: TextStyle(fontSize: 20),
            ),
            ImageSelector(),
            SizedBox(
              height: 30,
            ),
            Text(
              'NOMBRE DE TU LIBRETA',
              style: TextStyle(fontSize: 20),
            ),
            TextFormField(
              maxLength: 10,
              controller: controller.textEditingController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Privacidad'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Solo Amigos',
                  style:
                      TextStyle(color: controller.privado ? null : Colors.grey),
                ),
                Switch(
                  activeColor: pDark,
                  value: controller.privado,
                  onChanged: (value) {
                    controller.privado = value;
                    controller.notify();
                  },
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Amigos y Amigos',
                      style: TextStyle(
                          color: controller.privado ? Colors.grey : null),
                    ),
                    Text(
                      'de mis Amigos',
                      style: TextStyle(
                          color: controller.privado ? Colors.grey : null),
                    ),
                  ],
                ),
              ],
            ),
            FloatingActionButton.extended(
              heroTag: 'btnT1',
              onPressed: () {
                if (controller.textEditingController.text == '') {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text('El campo nombre no puede quedar vacío'),
                      ));
                  return;
                }

                controller.pageController.jumpToPage(1);
              },
              label: Text('Siguiente'),
            ),
          ],
        ),
      ),
    );
  }
}
