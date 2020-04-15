import 'package:flutter/material.dart';
import 'pages.dart';

class FormularioCreator extends StatelessWidget {
  final PageController pageController = PageController();
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: PageView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: pageController,
        children: <Widget>[first(),CreadorLP()],
      ),
    );
  }

  Widget first(){
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
            height: 10,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              pageController.jumpToPage(1);
            },
            icon: Icon(Icons.next_week),
            label: Text('Next'),
          ),
        ],
      ),
    );
  }
}


