import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/shared/shared.dart';
import 'package:trivia_form/services/services.dart';

class Store extends StatelessWidget {
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
              StoreItem(cantidad: '5',cantidadTexto: 'Cinco Monedas', precio: '5',),
              StoreItem(cantidad: '10', cantidadTexto: 'Diez Estrellas', precio: '9', save: '\$1',),
              StoreItem(cantidad: '20', cantidadTexto: 'Diez Estrellas', precio: '17', save: '\$3',)
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
  const StoreItem({Key key, this.cantidad, this.cantidadTexto, this.precio,this.save})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return Card(
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
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
                  color: Colors.yellow[600],
                  size: 20,
                ),
                SizedBox(width: 10,),
                Text(
                  cantidadTexto,
                  style: TextStyle(fontSize: 20),
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
                    size: 80,
                  ),
                  Text(
                    precio,
                    style: TextStyle(fontSize: 90),
                  ),
                ],
              ),
            ),
           save != null ? Container(margin: EdgeInsets.only(bottom: 10), child: Text( '¡Ahorra: ' + save +'!', style: TextStyle(fontSize: 30),)) : Container(),
            FloatingActionButton.extended(
              heroTag: 'store',
              onPressed: () async {
               var result = await controller.buyCoins(int.parse(cantidad));
               if(result){
                 showDialog(
                   context: context,
                   child: AlertDialog(
                     title: Text('Compra exitosa'),
                     content: Text('Felicidades has aquirido $cantidad monedas' ),
                   )
                 );
               }
               else{
                 showDialog(
                   context: context,
                   child: AlertDialog(
                     title: Text('Error'),
                     content: Text('Error en la compra' ),
                   )
                 );
               }
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
