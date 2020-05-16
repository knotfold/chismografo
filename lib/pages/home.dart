import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:ChisMe/pages/pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ChisMe/shared/shared.dart';
import 'pages.dart';
import 'package:provider/provider.dart';
import 'package:ChisMe/services/services.dart';
import 'dart:io';

class Home extends StatefulWidget {
  void pruena2() {}
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription<List<PurchaseDetails>> _subscription;

  List<String> productos = ['05monedas', '10monedas', '20monedas'];

  Future<void> initPlatformState(BuildContext context) async {
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });
    Future.delayed(Duration.zero, () async {
      Controller controller = Provider.of<Controller>(context, listen: false);

      Stream purchaseUpdated =
          InAppPurchaseConnection.instance.purchaseUpdatedStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList, controller);
      }, onDone: () {
        _subscription.cancel();
      }, onError: (error) {
        // handle error here.
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
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
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(canvasColor: primaryColor),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            // fixedColor: primaryColor,
            currentIndex: controller.seleccionado,
            selectedItemColor: secondaryColor,
            unselectedItemColor: pLight,
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
                      List<DocumentSnapshot> documents =
                          snapshot.data.documents;

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

                      List<DocumentSnapshot> documents =
                          snapshot.data.documents;

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
      ),
    );
  }

  void _handlePurchaseUpdates(purchases) {}

  void _listenToPurchaseUpdated(purchaseDetailsList, Controller controller) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.error) {
        handleError(purchaseDetails.error);
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          deliverProduct(purchaseDetails, controller);
        } else {
          _handleInvalidPurchase(purchaseDetails);
          return;
        }
      }
      if (Platform.isAndroid) {
        await InAppPurchaseConnection.instance.consumePurchase(purchaseDetails);
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchaseConnection.instance
            .completePurchase(purchaseDetails);
      }
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void deliverProduct(
      PurchaseDetails purchaseDetails, Controller controller) async {
    String cantidad = purchaseDetails.productID.substring(0, 2);
    var result = await controller.buyCoins(int.parse(cantidad));
    if (result) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text('¡Compra exitosa!', style: TextStyle(fontSize: 20),),
            content: Row(
              children: <Widget>[
                Text('Felicidades has aquirido $cantidad monedas'),
                  Icon(
                Icons.stars,
                color: Colors.yellow[800],
              ),
              ],
            ),
          ));
    } else {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Error', style: TextStyle(fontSize: 20),),
            content: Text('Error en la compra'),
          ));
    }
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Error al realizar la compra'),
          content: Text(
              'La compra a fallado, no se a realizado ningun cargo, por favor vuelve a intentarlo'),
        ));
  }

  void handleError(IAPError error) {
    print(error.details);
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Error al realizar la compra'),
          content: Text(
              'La compra a fallado, no se a realizado ningun cargo, por favor vuelve a intentarlo'),
        ));
  }
}
