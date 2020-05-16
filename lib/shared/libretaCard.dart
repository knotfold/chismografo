import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ChisMe/services/services.dart';
import 'package:ChisMe/shared/shared.dart';
import 'package:provider/provider.dart';

class LibretaCard extends StatefulWidget {
  final Controller controller;
  final FormularioModel formularioModel;

  const LibretaCard({Key key, this.formularioModel, this.controller})
      : super(key: key);

  @override
  _LibretaCardState createState() => _LibretaCardState();
}

class _LibretaCardState extends State<LibretaCard> {
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
                      widget.controller.toFillForm = widget.formularioModel;
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
                            image: NetworkImage(widget.formularioModel.imagen),
                          ),
                        ),
                        Divider(
                          color: Colors.white,
                        )
                      ],
                    ),
                    title: Text(
                      widget.formularioModel.nombre,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.formularioModel.creadorUsuario,
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
                              '${widget.formularioModel.usuarios.length} / 25',
                              style: TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: () {
                            List<String> razones = [
                              'Contenido Ofensivo',
                              'Contenido Pornográfico',
                              'Difamasión'
                            ];
                            showDialog(
                                context: context,
                                child: ReportDialog(
                                  razones: razones,
                                  formularioModel: widget.formularioModel,
                                ));
                          },
                          icon: Icon(
                            Icons.report,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
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

class ReportDialog extends StatefulWidget {
  const ReportDialog(
      {Key key, @required this.razones, @required this.formularioModel})
      : super(key: key);

  final List<String> razones;
  final FormularioModel formularioModel;

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  bool value = false;
  List<String> razones = [];
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of(context);
    return WillPopScope(
      onWillPop: () async{
        return !controller.loading;
      },
          child: AlertDialog(
        title: Text(
          'Reportar Libreta',
          style: TextStyle(fontSize: 30),
        ),
        content: Container(
          height: 300,
          width: 500,
          child: Column(
            children: <Widget>[
              Text('Selecciona el/los motivos para reportar esta libreta:'),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.razones.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                        title: Text(
                          widget.razones[index],
                          style: TextStyle(color: Colors.white),
                        ),
                        value: razones.contains(widget.razones[index]),
                        onChanged: (val) {
                          if (val) {
                            razones.add(widget.razones[index]);
                          } else {
                            razones.remove((widget.razones[index]));
                          }
                          setState(() {});
                        });
                  }),
            ],
          ),
        ),
        actions: controller.loading ? <Widget>[CircularProgressIndicator()] : <Widget>[
          FlatButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          RaisedButton(
              child: Text('Enviar reporte'),
              onPressed: () async {
                if (razones.isEmpty) {
                  return;
                }

                controller.loading = true;
                controller.notify();

                await Firestore.instance
                    .collection('reportes')
                    .add(widget.formularioModel.toMap());

                showDialog(
                    context: context,
                    child: WillPopScope(
                      onWillPop: () async {
                        controller.loading = false;
                        Navigator.of(context).pop();
                        return !controller.loading;
                      },
                      child: AlertDialog(
                        backgroundColor: Colors.white,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Estamos revisando tu reporte, si tu reporte es valido, la libreta sera eliminada en aproximadamente 24 horas',
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 100,
                            )
                          ],
                        ),
                      ),
                    ));
              })
        ],
      ),
    );
  }
}
