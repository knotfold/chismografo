import 'package:ChisMe/pages/chat.dart';
import 'package:ChisMe/shared/miniProfile.dart';
import 'package:flutter/material.dart';
import 'package:ChisMe/services/services.dart';
import 'package:provider/provider.dart';
import 'package:ChisMe/services/services.dart';

class AmigoTile extends StatelessWidget {
  const AmigoTile({
    Key key,
    @required this.usuario,
    @required this.miniProfile,
  }) : super(key: key);

  final UsuarioModel usuario;
  final bool miniProfile;

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return ListTile(
      onTap: () {
        if (miniProfile) {
          showDialog(
              context: context,
              child: MiniProfile(
                usuario: usuario,
              ));
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Chat(
              usuarios: [
                usuario.usuario,
                controller.usuario.usuario,
              ],
              nombre: usuario.nombre,
              foto: usuario.foto,
              group: false,
            ),
          ),
        );
      },
      leading: CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage(usuario.foto),
      ),
      title: Text(
        usuario.nombre,
        style: TextStyle(fontSize: 18),
      ),
      subtitle: Text(usuario.usuario),
    );
  }
}
