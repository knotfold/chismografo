import 'package:flutter/material.dart';
import 'package:trivia_form/services/services.dart';
import 'shared.dart';

class AmigoTile extends StatelessWidget {
  const AmigoTile({
    Key key,
    @required this.usuario,
  }) : super(key: key);

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          child: MiniProfile(usuario: usuario,),
        );
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(usuario.foto),
      ),
      title: Text(usuario.nombre),
    );
  }
}