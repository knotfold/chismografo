import 'package:flutter/material.dart';
import 'package:trivia_form/shared/shared.dart';
import 'pages.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
   int seleccionado = 0;

  List<Widget> _widgetOptions = <Widget>[
    TusLibretas(),
    LibretasA(),
    Amigos(),
    Perfil(),
    Info(),
  ];

  _onItemTapped(int index) {
    setState(() {
      seleccionado = index;
     
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: _widgetOptions.elementAt(seleccionado),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: seleccionado,
          backgroundColor: Colors.black,
          fixedColor: Colors.black,
          onTap: (int index) {
            _onItemTapped(index);
          },
        items: const <BottomNavigationBarItem>[
            
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text('Tus Libretas'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.collections_bookmark),
              title: Text('Libretas Amigos'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              title: Text('Amigos'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Perfil'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              title: Text('Info'),
            ),
            
          ],
      ),
    );
  }
}
