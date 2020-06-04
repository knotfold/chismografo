import 'package:flutter/material.dart';
import 'package:ChisMe/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:ChisMe/shared/shared.dart';

class MiniProfile extends StatefulWidget {
  final UsuarioModel usuario;
  MiniProfile({this.usuario});

  @override
  _MiniProfileState createState() => _MiniProfileState();
}

class _MiniProfileState extends State<MiniProfile> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    if (verifyFriendship(controller)) {
      controller.usuario.solicitudesAE.remove(widget.usuario.documentId);
    }

    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.start,
      alignment: WrapAlignment.center,
      children: [
        !controller.usuario.monedasFree &&
                controller.usuario.usuario != widget.usuario.usuario
            ? isLoading
                ? Center(child: CircularProgressIndicator())
                : FlatButton.icon(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        child: ConfirmationDialog(
                          usuario: widget.usuario,
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.stars,
                      size: 15,
                      color: Colors.white,
                    ),
                    label: Text('Regalar \nMonedas'))
            : Container(),
        FlatButton.icon(
            onPressed: () {
              showDialog(
                  context: context,
                  child: WillPopScope(
                    onWillPop: () async {
                      Navigator.of(context).pop();
                     
                      return !controller.loading;
                    },
                    child: WillPopScope(
                      onWillPop: () async {
                        return false;
                      },
                      child: AlertDialog(
                        backgroundColor: Colors.white,
                        content: Text(
                          '¿Seguro que deseas bloquear a este usuario?',
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: [
                          RaisedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              return;
                            },
                            child: Text('No'),
                          ),
                          RaisedButton(
                            onPressed: () async {
                              controller.loading = true;
                              controller.notify();
                              await controller.usuario.reference.updateData({
                                'amigos': FieldValue.arrayRemove(
                                    [widget.usuario.usuario]),
                              });
                              await widget.usuario.reference.updateData({
                                'amigos': FieldValue.arrayRemove(
                                    [controller.usuario.usuario]),
                                'bloqueados': FieldValue.arrayUnion(
                                    [controller.usuario.usuario]),
                              });
                              controller.loading = false;
                              controller.notify();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              return;
                            },
                            child: Text('Si'),
                          )
                        ],
                        title: Text(
                          'Bloquear Usuario',
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),
                      ),
                    ),
                  ));
            },
            icon: Icon(
              Icons.report,
              size: 15,
            ),
            label: Text(
              'Bloquear \nUsuario',
              style: TextStyle(fontSize: 15),
            )),
        FlatButton.icon(
            onPressed: () {
              List<String> razones = [
                'Contenido Ofensivo',
                'Contenido Pornográfico',
                'Difamasión',
                'Robo de identidad',
              ];
              showDialog(
                  context: context,
                  child: ReportDialog(
                    razones: razones,
                    usuarioModel: widget.usuario,
                  ));
            },
            icon: Icon(
              Icons.block,
              size: 15,
            ),
            label: Text(
              'Reportar \nUsuario',
              style: TextStyle(fontSize: 15),
            )),
        controller.usuario.documentId == widget.usuario.documentId
            ? Container()
            : controller.loading
                ? CircularProgressIndicator()
                : verifyMyFRequest(controller)
                    ? FlatButton.icon(
                        onPressed: () async {
                          print(widget.usuario.documentId.length);
                          await controller.usuario.reference.updateData({
                            'solicitudesAE': FieldValue.arrayRemove(
                                [widget.usuario.documentId])
                          });
                          controller.usuario.solicitudesAE
                              .remove(widget.usuario.documentId);
                          controller.notify();
                        },
                        icon: Icon(
                          Icons.cancel,
                          size: 15,
                          color: Colors.white,
                        ),
                        label: Text('Cancelar \nSolicitud'))
                    : verifyItsFRequest(controller)
                        ? Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: () async {
                                  controller.loading = true;
                                  controller.notify();
                                  await controller.usuario.reference
                                      .updateData({
                                    'amigos': FieldValue.arrayUnion(
                                        [widget.usuario.documentId])
                                  });
                                  await widget.usuario.reference.updateData({
                                    'amigos': FieldValue.arrayUnion(
                                        [controller.usuario.documentId]),
                                    'solicitudesAE': FieldValue.arrayRemove(
                                        [controller.usuario.documentId]),
                                  });
                                  controller.usuario.amigos
                                      .add(widget.usuario.documentId);
                                  controller.usuario.solicitudesAE
                                      .remove(widget.usuario.documentId);
                                  controller.loading = false;
                                  controller.notify();
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.check,
                                  size: 15,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  controller.loading = true;
                                  controller.notify();
                                  await widget.usuario.reference.updateData({
                                    'solicitudesAE': FieldValue.arrayRemove(
                                        [controller.usuario.documentId])
                                  });
                                  controller.loading = false;
                                  controller.notify();
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ],
                          )
                        : verifyFriendship(controller)
                            ? FlatButton.icon(
                                label: Text(
                                  'Eliminar',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  controller.loading = true;
                                  controller.notify();
                                  await controller.usuario.reference
                                      .updateData({
                                    'amigos': FieldValue.arrayRemove(
                                        [widget.usuario.documentId])
                                  });
                                  await widget.usuario.reference.updateData({
                                    'amigos': FieldValue.arrayRemove(
                                        [controller.usuario.documentId])
                                  });
                                  controller.usuario.amigos
                                      .remove(widget.usuario.documentId);
                                  controller.loading = false;
                                  controller.notify();
                                  Navigator.of(context).pop();
                                },
                              )
                            : FlatButton.icon(
                                label: Text(
                                  'Agregar',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                onPressed: () async {
                                  controller.loading = true;
                                  controller.notify();
                                  await controller.usuario.reference
                                      .updateData({
                                    'solicitudesAE': FieldValue.arrayUnion(
                                        [widget.usuario.documentId]),
                                  });
                                  controller.usuario.solicitudesAE
                                      .add(widget.usuario.documentId);
                                  controller.loading = false;
                                  controller.notify();
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.person_add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
      ],
    );
  }

  bool verifyFriendship(Controller controller) {
    return widget.usuario.amigos.contains(controller.usuario.documentId);
  }

  bool verifyMyFRequest(Controller controller) {
    return controller.usuario.solicitudesAE.contains(widget.usuario.documentId);
  }

  bool verifyItsFRequest(Controller controller) {
    return widget.usuario.solicitudesAE.contains(controller.usuario.documentId);
  }
}

class ConfirmationDialog extends StatefulWidget {
  final UsuarioModel usuario;
  ConfirmationDialog({this.usuario});
  @override
  _ConfirmationDialogState createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return WillPopScope(
      onWillPop: () async {
        return isLoading ? false : true;
      },
      child: AlertDialog(
        title: Text('¿Estas seguro de esta decisión?'),
        content:
            Text('Ten en cuenta que solo podrás realizar esta acción una vez.'),
        actions: isLoading
            ? <Widget>[CircularProgressIndicator()]
            : <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'No',
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    await Firestore.instance
                        .collection('usuarios')
                        .document(widget.usuario.documentId)
                        .updateData({
                      'coins': widget.usuario.coins + 25,
                    });

                    await controller.usuario.reference.updateData({
                      'coins': controller.usuario.coins + 25,
                      'monedasFree': true,
                    });

                    controller.usuario.coins = controller.usuario.coins + 25;

                    controller.usuario.monedasFree = true;

                    controller.notify();

                    print(widget.usuario.documentId);

                    setState(() {
                      isLoading = false;
                    });

                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Sí',
                  ),
                )
              ],
      ),
    );
  }
}

class ReportDialog extends StatefulWidget {
  const ReportDialog(
      {Key key, @required this.razones, @required this.usuarioModel})
      : super(key: key);

  final List<String> razones;
  final UsuarioModel usuarioModel;

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
      onWillPop: () async {
        return !controller.loading;
      },
      child: AlertDialog(
        title: Text(
          'Reportar Usuario',
          style: TextStyle(fontSize: 30),
        ),
        content: Container(
          height: 300,
          width: 500,
          child: Column(
            children: <Widget>[
              Text('Selecciona el/los motivos para reportar a este usuario:'),
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
        actions: controller.loading
            ? <Widget>[CircularProgressIndicator()]
            : <Widget>[
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
                          .add(widget.usuarioModel.toReport(razones));

                      showDialog(
                          context: context,
                          child: WillPopScope(
                            onWillPop: () async {
                              controller.loading = false;
                              Navigator.of(context).pop();
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
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
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
