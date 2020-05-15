import 'package:flutter/material.dart';
import 'package:ChisMe/services/services.dart';

class LibretaCard extends StatelessWidget {
  final Controller controller;
  final FormularioModel formularioModel;

  const LibretaCard({Key key, this.formularioModel, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      height: 120,
      child: Card(
          color: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 10),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                    colors: [
                      Color(0xFF0f2027),
                      Color(0xFF203a43),
                      Color(0xFF2c5364)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    tileMode: TileMode.clamp)),
            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),gradient:LinearGradient(colors: [Color(0xFF0f2027),Color(0xFF021B79),Color(0xFF0575E6)],begin: Alignment.topLeft,end: Alignment.topRight,tileMode: TileMode.clamp )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    onTap: () {
                      controller.toFillForm = formularioModel;
                      Navigator.of(context).pushNamed('/libretaDetalles');
                    },
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(360),
                          child: FadeInImage(
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.cover,
                            placeholder: AssetImage('assets/zany-face.png'),
                            width: 50,
                            height: 50,
                            image: NetworkImage(formularioModel.imagen),
                          ),
                        ),
                        Divider(
                          color: Colors.white,
                        )
                      ],
                    ),
                    title: Text(
                      formularioModel.nombre,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(formularioModel.creadorUsuario,
                            style: TextStyle(color: Colors.white54)),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Participantes: ',
                              style: TextStyle(color: Colors.white54),
                            ),
                            Text(
                              '${formularioModel.usuarios.length} / 25',
                              style: TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )

          // ListTile(
          //   onTap: () {
          //     controller.toFillForm = formularioModel;
          //     Navigator.of(context)
          //         .pushNamed('/libretaDetalles');
          //   },
          //   title: Text(
          //     formularioModel.nombre,
          //     style: TextStyle(fontSize: 20),
          //   ),
          //   subtitle: Text(formularioModel.creadorUsuario),
          //   trailing: Text(
          //       '${formularioModel.usuarios.length} / 25'),
          // ),
          ),
    );
  }
}
