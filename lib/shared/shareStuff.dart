import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/services/services.dart';
import 'package:trivia_form/main.dart';
import 'package:trivia_form/shared/colors.dart';

AppBar myAppBar(Controller controller) {
  return AppBar(
    centerTitle: true,
    
    backgroundColor: buttonColors,
    elevation: 0,
    title: Text('Chismografo',style: TextStyle(color: Colors.white),),
    actions: <Widget>[
      Container(
        margin: EdgeInsets.only(right: 15),
        child: Row(
          children: <Widget>[
            
                 IconButton(
            icon: Icon(Icons.stars),

            color: Colors.yellow[500],
            onPressed: () => null,

          ),
          Text(
                  controller.usuario.coins.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                ),
          ],
        ),
              
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
