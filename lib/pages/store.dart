import 'dart:async';
import 'dart:io' show Platform;
import 'package:ads/ads.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ChisMe/shared/shared.dart';
import 'package:ChisMe/services/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class Store extends StatefulWidget {
  final Ads appAds;
  Store({this.appAds});
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  List<String> productos = ['05monedas', '10monedas', '20monedas'];
  List<String> iosProductos = [
    '25monedas',
    '52monedas',
    '80monedas',
    'com.example.rocket_car'
  ];

  Future<List<ProductDetails>> getItems() async {
    List<ProductDetails> productDetails = [];
    if (Platform.isAndroid) {
      final ProductDetailsResponse response = await InAppPurchaseConnection
          .instance
          .queryProductDetails(productos.toSet());
      if (response.notFoundIDs.isNotEmpty) {
        print('error');
      }
      productDetails = response.productDetails;
      return productDetails;
    } else {
      final ProductDetailsResponse response = await InAppPurchaseConnection
          .instance
          .queryProductDetails(iosProductos.toSet());
      if (response.notFoundIDs.isNotEmpty) {
        print('error');
      }
      productDetails = response.productDetails;
      return productDetails;
    }
  }

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
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
                  print('finally');
                  List<ProductDetails> products = snapshot.data;
                  return products.isEmpty
                      ? Text(
                          'La tiendad no esta disponible, pero las recompensas gratis si :)')
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return StoreItem(
                              cantidad: products[index].title.substring(0, 2),
                              cantidadTexto: products[index].title,
                              precio: products[index].price,
                              productDetails: products[index],
                            );
                          },
                        );
                },
              ),
              StoreItemFree(
                cantidad: '5',
                cantidadTexto:
                    'Cinco Monedas Gratis por cada vez que contestes una libreta',
                opcion: 'Ir a Libretas de Amigos',
                oportunidades: controller.usuario.dailyAnswers.toString(),
                newIndex: 1,
              ),
              StoreItemFree(
                cantidad: '5',
                cantidadTexto:
                    'Cinco Monedas Gratis por cada vez que crees una libreta',
                opcion: 'Ir a tus libretas',
                oportunidades: controller.usuario.dailyFormularios.toString(),
                newIndex: 0,
              ),
              StoreItemVideo(
                cantidad: '2',
                cantidadTexto: 'Dos Monedas mirando un anuncio',
                opcion: 'Mirar Anuncio',
                appAds: widget.appAds,
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
  final ProductDetails productDetails;
  const StoreItem(
      {Key key,
      this.cantidad,
      this.cantidadTexto,
      this.precio,
      this.save,
      this.productDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  border: Border.all(width: 4, color: secondaryColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    precio,
                    style: TextStyle(fontSize: 42),
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
              heroTag: null,
              onPressed: () async {
                final PurchaseParam purchaseParam =
                    PurchaseParam(productDetails: productDetails);
                if (_isConsumable(productDetails)) {
                  InAppPurchaseConnection.instance
                      .buyConsumable(purchaseParam: purchaseParam);
                } else {
                  InAppPurchaseConnection.instance
                      .buyNonConsumable(purchaseParam: purchaseParam);
                }
              },
              label: Text('Comprar'),
              icon: Icon(Icons.credit_card, color: primaryColor,),
            ),
          ],
        ),
      ),
    );
  }

  bool _isConsumable(ProductDetails productDetails) {
    return true;
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
                  border: Border.all(width: 4, color: secondaryColor)),
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
              heroTag: null,
              onPressed: () async {
                controller.seleccionado = newIndex;
                controller.notify();
              },
              label: Text(opcion),
              icon: Icon(Icons.navigate_before, color: primaryColor,),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreItemVideo extends StatefulWidget {
  final String cantidad;
  final String cantidadTexto;
  final String opcion;
  final String oportunidades;
  final int newIndex;
  final Ads appAds;
  const StoreItemVideo({
    Key key,
    this.cantidad,
    this.cantidadTexto,
    this.opcion,
    this.oportunidades,
    this.newIndex,
    this.appAds
  }) : super(key: key);

  @override
  _StoreItemVideoState createState() => _StoreItemVideoState();
}

class _StoreItemVideoState extends State<StoreItemVideo> {
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
                  widget.cantidad,
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
                    widget.cantidadTexto,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Oportunidades infinitas',
              style: TextStyle(fontSize: 20),
            ),
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border.all(width: 4, color: secondaryColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                ':)',
                    style: TextStyle(fontSize: 40),
                  ),
                ],
              ),
            ),
            FloatingActionButton.extended(
              heroTag: null,
              
              onPressed: () async {
              
              widget.appAds.showVideoAd(state: this);
              },
              label: Text(widget.opcion),
              icon: Icon(Icons.movie, color: primaryColor,),
            ),
          ],
        ),
      ),
    );
  }
}
