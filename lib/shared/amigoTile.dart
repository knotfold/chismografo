import 'package:ChisMe/pages/chat.dart';
import 'package:ChisMe/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:ChisMe/services/services.dart';
import 'package:provider/provider.dart';
import 'package:ChisMe/pages/pages.dart';

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
    return  !usuario.userChat && !miniProfile  ? Container() : ListTile(
      onTap: () {
        if (miniProfile) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Perfil(
                    usuario: usuario,
                  )));
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Chat(
              usuario: usuario,
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
        //    showDialog(
        //   context: context,
        //   child: MiniProfile(usuario: usuario,),
        // );
      },
      leading: Stack(
        children: <Widget>[
         
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(usuario.foto),
          ), !usuario.userCheck 
              ? Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: secondaryColor),
                )
              : Container(width: 10, height: 10,),
        ],
      ),
      title: Text(
        usuario.nombre,
        style: TextStyle(fontSize: 18),
      ),
      subtitle: Text(usuario.usuario),
    );
  }
}
