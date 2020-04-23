import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/services/services.dart';
import 'package:trivia_form/main.dart';

AppBar myAppBar(Controller controller) {
  return AppBar(
    centerTitle: true,
    
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text('Chismografo'),
    actions: <Widget>[
      Text(
            controller.usuario.coins.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          IconButton(
            icon: Icon(Icons.stars),
            color: Colors.yellow[400],
            onPressed: () => null,

          ),
    ],
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
          elevation: 1,
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
