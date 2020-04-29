import 'dart:async';
import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:trivia_form/pages/pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trivia_form/shared/shared.dart';
import 'pages.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/services/services.dart';

class Home extends StatefulWidget {
  void pruena2() {}
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription purchaseUpdatedSubscription;
  StreamSubscription purchaseErrorSubscription;
  String platformVersion = 'Unknown';
  List<String> productos = ['05monedas', '10monedas', '20monedas'];

  Future<void> initPlatformState(BuildContext context) async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterInappPurchase.instance.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // prepare
    var result = await FlutterInappPurchase.instance.initConnection;
    print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

      platformVersion = platformVersion;
    

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAllItems;
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      Future.delayed(Duration.zero, () async {
        Controller controller = Provider.of<Controller>(context, listen: false);
        await FlutterInappPurchase.instance.consumeAllItems;
        String cantidad = productItem.productId.substring(0, 2);
        var result = await controller.buyCoins(int.parse(cantidad));
        if (result) {
          showDialog(
              context: context,
              child: AlertDialog(
                title: Text('Compra exitosa'),
                content: Text('Felicidades has aquirido $cantidad monedas'),
              ));
        } else {
          showDialog(
              context: context,
              child: AlertDialog(
                title: Text('Error'),
                content: Text('Error en la compra'),
              ));
        }
      });
      print('purchase-updated: $productItem');
    });

    purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Error en la compra vuelve a intentar'),
            content: Text('Error en la compra :( '),
          ));

      print('purchase-error: $purchaseError');
    });
  }

  List<Widget> _widgetOptions = <Widget>[
    TusLibretas(),
    LibretasA(),
    Amigos(),
    Perfil(),
    Store(),
  ];

  @override
  void initState() {
    super.initState();
    FirebaseMessage firebaseMessage = FirebaseMessage();
    initPlatformState(context);
  }

  _onItemTapped(int index, Controller controller) {
    setState(() {
      controller.seleccionado = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: _widgetOptions.elementAt(controller.seleccionado),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.seleccionado,
          backgroundColor: Colors.black,
          fixedColor: Colors.black,
          unselectedItemColor: Colors.blueGrey,
          onTap: (int index) {
            _onItemTapped(index, controller);
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text('Tus Libretas'),
            ),
            BottomNavigationBarItem(
              icon: StreamBuilder(
                  stream: Firestore.instance
                      .collection('formularios')
                      .where('invitaciones',
                          arrayContains: controller.usuario.usuario)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const Icon(Icons.collections_bookmark);
                    List<DocumentSnapshot> documents = snapshot.data.documents;

                    return documents.isEmpty
                        ? Icon(Icons.collections_bookmark)
                        : Stack(
                            children: <Widget>[
                              Container(
                                  child: Icon(
                                    Icons.collections_bookmark,
                                  ),
                                  width: 30,
                                  height: 30),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(right: 20),
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: yemahuevo),
                              )
                            ],
                          );
                  }),
              title: Text('Libretas Amigos'),
            ),
            BottomNavigationBarItem(
              icon: StreamBuilder(
                  stream: Firestore.instance
                      .collection('usuarios')
                      .where('solicitudesAE',
                          arrayContains: controller.usuario.documentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Icon(Icons.group);

                    List<DocumentSnapshot> documents = snapshot.data.documents;

                    return documents.isEmpty
                        ? Icon(Icons.contacts)
                        : Stack(
                            children: <Widget>[
                              Container(
                                  child: Icon(
                                    Icons.contacts,
                                  ),
                                  width: 30,
                                  height: 30),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(right: 20),
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: yemahuevo),
                              )
                            ],
                          );
                  }),
              title: Text('Amigos'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Perfil'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              title: Text('Tienda'),
            ),
          ],
        ),
      ),
    );
  }
}
