import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trivia_form/shared/shared.dart';
import 'package:trivia_form/services/services.dart';
import 'package:provider/provider.dart';

class AmigosSelector extends StatefulWidget {
  @override
  _AmigosSelectorState createState() => _AmigosSelectorState();
}

class _AmigosSelectorState extends State<AmigosSelector> {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    // TODO: implement build
    return Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      Text(
        'Selecciona a los participantes (${controller.participantes.length}/25)',
        style: TextStyle(fontSize: 25),
      ),
      Expanded(
              child: StreamBuilder(
          stream: Firestore.instance
              .collection('usuarios')
              .where('amigos', arrayContains: controller.usuario.documentId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            List<DocumentSnapshot> documents = snapshot.data.documents;
            return documents.isEmpty
                ? Text('No tienes Amigos aún :C ' )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      UsuarioModel usuarioModel =
                          UsuarioModel.fromDocumentSnapshot(documents[index]);
                      return ListTile(
                        title: Text(usuarioModel.nombre),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(usuarioModel.foto),
                        ),
                        trailing: Checkbox(
                          activeColor: pDark,
                            value: controller.participantes
                                .contains(usuarioModel.usuario),
                            onChanged: (value) {
                              if (value) {
                                if (controller.participantes.length >= 25) {
                                  showDialog(
                                      context: context,
                                      child: Dialog(
                                        child: AlertDialog(
                                          title: Text(
                                              'El limite Maximo de participantes es 25'),
                                        ),
                                      ));
                                  return;
                                }
                                controller.participantes
                                    .add(usuarioModel.usuario);
                              
                                print(controller.participantes);
                                controller.notify();
                                return;
                              } else {
                                controller.participantes
                                    .remove(usuarioModel.usuario);
                              
                                print(controller.participantes);
                             

                                controller.notify();
                              }
                            }),
                      );
                    },
                  );
          },
        ),
      ),
      controller.loading ? CircularProgressIndicator() : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 60,
            height: 40,
            child: FloatingActionButton.extended(
              
              heroTag: 'btn1',
              onPressed: () {
                controller.pageController.jumpToPage(1);
              },
              label: Text('Back'),
            ),
          ),
          Container(
            width: 60,
            height: 40,
            child: FloatingActionButton.extended(
              heroTag: 'btn2',
              onPressed: () async {
               bool success = await controller.crearFormulario(context);
                if(!success){
                  return;
                }
                if (controller.usuario.dailyFormularios > 0) {
                  controller.usuario.dailyFormularios =
                      controller.usuario.dailyFormularios - 1;
                  controller.loading = true;
                  controller.notify();
                  showDialog(
                    context: context,
                    child: WillPopScope(
                      onWillPop: () async {
                        return false;
                      },
                      child: CoinRewardDialogF(),
                    ),
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home', ModalRoute.withName('/'));
                  print('Todo bien');

                  return;
                }
              },
              label: Text('Crear'),
            ),
          ),
        ],
      ),
    ],
        ),
      );
  }
}

class CoinRewardDialogF extends StatelessWidget {
  const CoinRewardDialogF({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return AlertDialog(
      title: Text('¡Felicidades!', style: TextStyle(fontSize: 30),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.stars,
                color: Colors.yellow[800],
              ),
              Expanded(
                              child: Text(
                    'Haz ganado una recompensa de 5 Monedas por crear esta Libreta', style: TextStyle(fontSize: 20),),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Text(
              'Te quedan ${controller.usuario.dailyFormularios} de 3 oportunidades para recibir mas monedas'),
        ],
      ),
      actions: <Widget>[
        RaisedButton(
          child: Row(
            children: <Widget>[Text('Continuar')],
          ),
          onPressed: () async {
            controller.usuario.coins = controller.usuario.coins + 5;
            await controller.usuario.reference.updateData({
              'dailyFormularios': controller.usuario.dailyFormularios,
              'coins' : controller.usuario.coins
            });
            controller.loading = false;
            controller.notify();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/home', ModalRoute.withName('/'));
          },
        )
      ],
    );
  }
}
