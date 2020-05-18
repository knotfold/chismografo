import 'package:flutter/material.dart';
import 'package:ChisMe/services/services.dart';
import 'package:provider/provider.dart';
import 'package:ChisMe/services/services.dart';

class AmigoTile extends StatelessWidget {
  const AmigoTile({
    Key key,
    @required this.usuario,
  }) : super(key: key);

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed('/chat',arguments: {[usuario.usuario, controller.usuario.usuario] , usuario.nombre, usuario.foto });
      },
      leading: CircleAvatar(
        radius:22 ,
        backgroundImage: NetworkImage(usuario.foto),
      ),
      title: Text(usuario.nombre,style: TextStyle(fontSize: 18),),
      subtitle: Text(usuario.usuario),
    );
  }
}