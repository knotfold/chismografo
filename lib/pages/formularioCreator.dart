import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/services/services.dart';
import 'package:trivia_form/pages/pages.dart';

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
          elevation: 1,
        ),
        body: PageView(
          physics: controller.loading
              ? NeverScrollableScrollPhysics()
              : BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          controller: controller.pageController,
          children: <Widget>[first(controller), CreadorLP(), AmigosSelector()],
        ),
      ),
    );
  }

  Widget first(Controller controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ImageSelector(),
            SizedBox(
              height: 30,
            ),
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
                Text(
                  'Solo Amigos',
                  style:
                      TextStyle(color: controller.privado ? null : Colors.grey),
                ),
                Switch(
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
