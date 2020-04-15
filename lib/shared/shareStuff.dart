import 'package:flutter/material.dart';

AppBar myAppBar() {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text('Chismografo'),
  );
}

Drawer myDrawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: <Widget>[
        AppBar(
          // centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Ménu'),
        ),
        ListTile(
          onTap: () =>
              Navigator.of(context).pushReplacementNamed('/misLibretas'),
          title: Text('Tus libretas'),
          leading: Icon(Icons.book),
        ),
        ListTile(
          onTap: () =>
              Navigator.of(context).pushReplacementNamed('/libretasAmigos'),
          title: Text('Libretas de Amigos'),
          leading: Icon(Icons.bookmark),
        ),
        ListTile(
          title: Text('Info'),
          leading: Icon(Icons.info),
        ),
      ],
    ),
  );
}
