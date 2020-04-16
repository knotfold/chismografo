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
        children: <Widget>[first(controller.textEditingController, controller.pageController),CreadorLP(),AmigosSelector()],
      ),
    );
  }

  Widget first(TextEditingController textEditingController, PageController pageController){
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
            controller: textEditingController,
            decoration: InputDecoration(
              labelText: 'Nombre',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              pageController.jumpToPage(1);
            },
           
            label: Text('Siguiente'),
          ),
        ],
      ),
    );
  }
}


