import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/shared/shared.dart';
import 'package:trivia_form/services/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class Store extends StatefulWidget {
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  List<String> productos = ['05monedas', '10monedas', '20monedas'];

  Future<List<IAPItem>> getItems() async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts(productos);
    for (var item in items) {
      print('${item.toString()}');
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: myAppBar(controller, context),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: getItems(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const LinearProgressIndicator();
                  List<IAPItem> products = snapshot.data;
                  return products.isEmpty
                      ? Text('La tiendad no esta disponible')
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return StoreItem(
                              cantidad: products[index].title.substring(0, 2),
                              cantidadTexto: products[index].title,
                              precio: products[index].price,
                              iapItem: products[index],
                            );
                          },
                        );
                },
              ),
              StoreItemFree(
                cantidad: '5',
                cantidadTexto:
                    'Cinco Estrellas Gratis por cada vez que contestes una libreta',
                opcion: 'Ir a Libretas de Amigos',
                oportunidades: controller.usuario.dailyAnswers.toString(),
                newIndex: 1,
              ),
              StoreItemFree(
                cantidad: '5',
                cantidadTexto:
                    'Cinco Estrellas Gratis por cada vez que crees una libreta',
                opcion: 'Ir a tus libretas',
                oportunidades: controller.usuario.dailyFormularios.toString(),
                newIndex: 0,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StoreItem extends StatelessWidget {
  final String precio;
  final String cantidad;
  final String cantidadTexto;
  final String save;
  final IAPItem iapItem;
  const StoreItem(
      {Key key,
      this.cantidad,
      this.cantidadTexto,
      this.precio,
      this.save,
      this.iapItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return Card(
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  cantidad,
                  style: TextStyle(fontSize: 20),
                ),
                Icon(
                  Icons.stars,
                  color: Colors.yellow[800],
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    cantidadTexto,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border.all(width: 4, color: backgroundColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.attach_money,
                    size: 70,
                  ),
                  Text(
                    precio,
                    style: TextStyle(fontSize: 80),
                  ),
                ],
              ),
            ),
            save != null
                ? Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      '¡Ahorra: ' + save + '!',
                      style: TextStyle(fontSize: 30),
                    ))
                : Container(),
            FloatingActionButton.extended(
              heroTag: 'store',
              onPressed: () async {
                FlutterInappPurchase.instance
                    .requestPurchase(iapItem.productId);
                // var result =
                //     await controller.buyCoins(int.parse(cantidad), iapItem);
                // if (result) {
                //   showDialog(
                //       context: context,
                //       child: AlertDialog(
                //         title: Text('Compra exitosa'),
                //         content:
                //             Text('Felicidades has aquirido $cantidad monedas'),
                //       ));
                // } else {
                //   showDialog(
                //       context: context,
                //       child: AlertDialog(
                //         title: Text('Error'),
                //         content: Text('Error en la compra'),
                //       ));
                // }
              },
              label: Text('Comprar'),
              icon: Icon(Icons.credit_card),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreItemFree extends StatelessWidget {
  final String cantidad;
  final String cantidadTexto;
  final String opcion;
  final String oportunidades;
  final int newIndex;
  const StoreItemFree({
    Key key,
    this.cantidad,
    this.cantidadTexto,
    this.opcion,
    this.oportunidades,
    this.newIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return Card(
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  cantidad,
                  style: TextStyle(fontSize: 20),
                ),
                Icon(
                  Icons.stars,
                  color: Colors.yellow[800],
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    cantidadTexto,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Oportunidades hoy',
              style: TextStyle(fontSize: 20),
            ),
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border.all(width: 4, color: backgroundColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$oportunidades / 3',
                    style: TextStyle(fontSize: 60),
                  ),
                ],
              ),
            ),
            FloatingActionButton.extended(
              heroTag: 'store',
              onPressed: () async {
                controller.seleccionado = newIndex;
                controller.notify();
              },
              label: Text(opcion),
              icon: Icon(Icons.navigate_before),
            ),
          ],
        ),
      ),
    );
  }
}
