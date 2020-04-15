import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/services/services.dart';
import 'package:trivia_form/main.dart';

AppBar myAppBar() {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text('Chismografo'),
  );
}

Drawer myDrawer(BuildContext context) {
  Controller controller = Provider.of<Controller>(context);
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
        ListTile(
          title: Text('Cerrar Sesión'),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () async {
              signOutGoogle();
              await controller.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', ModalRoute.withName('/home'));
            },
          ),
        )
      ],
    ),
  );
}
