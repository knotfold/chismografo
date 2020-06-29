import 'dart:async';
import 'package:ads/ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:ChisMe/pages/pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ChisMe/shared/shared.dart';
import 'pages.dart';
import 'package:provider/provider.dart';
import 'package:ChisMe/services/services.dart';
import 'dart:io';

import 'dart:io' show Platform;
import 'package:firebase_admob/firebase_admob.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}



class _HomeState extends State<Home> {
  Ads appAds;
  final String appId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544~3347511713'
      : 'ca-app-pub-3940256099942544~1458002511';

  final String bannerUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  final String screenUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  final String videoUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  UsuarioModel usuarioModel;

  StreamSubscription<List<PurchaseDetails>> _subscription;
  Future myFuture;

  List<String> productos = ['05monedas', '10monedas', '20monedas'];

  Future<void> initPlatformState(BuildContext context) async {
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });
    Future.delayed(Duration.zero, () async {
      


      Controller controller = Provider.of<Controller>(context, listen: false);


       var eventListener = (MobileAdEvent event) {
      if (event == MobileAdEvent.opened) {
        print("eventListener: The opened ad is clicked on.");
      }
    };

    appAds = Ads(
      appId,
      bannerUnitId: bannerUnitId,
      screenUnitId: screenUnitId,
      keywords: <String>['ibm', 'computers'],
      contentUrl: 'http://www.ibm.com',
      childDirected: false,
      testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
      testing: false,
      listener: eventListener,
    );
 
    appAds.setVideoAd(
      adUnitId: videoUnitId,
      keywords: ['dart', 'java'],
      contentUrl: 'http://www.publang.org',
      childDirected: true,
      testDevices: null,
      listener: (RewardedVideoAdEvent event,
          {String rewardType, int rewardAmount}) {
        print("The ad was sent a reward amount.");
        setState(() {
            // controller.usuarioAct.coins = controller.usuarioAct.coins + 5;
            // controller.notify();
        });
      },
    );

    _setEventListeners(appAds, controller, context);

    

    // appAds.showBannerAd();





      usuarioModel = controller.usuario;

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
    appAds?.dispose();
    super.dispose();
  }

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

  Future<bool> checkIfMessage(
      List<DocumentSnapshot> list, Controller controller) async {
    bool message = true;
    for (var element in list) {
      bool check = element[controller.usuarioAct.usuario + 'Check'] ?? true;

      if (!check) {
        message = false;
        break;
      }
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of(context);
    List<Widget> _widgetOptions = <Widget>[
      TusLibretas(),
      LibretasA(),
      Amigos(),
      Chats(),
      Store(appAds: appAds,),
    ];
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: _widgetOptions.elementAt(controller.seleccionado),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.white),
          child: BottomNavigationBar( 
            type: BottomNavigationBarType.shifting,
            backgroundColor: Colors.transparent,
            // fixedColor: primaryColor,
            currentIndex: controller.seleccionado,
            selectedItemColor: primaryColor ,
            unselectedItemColor: Colors.black45,
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
                    
                     controller.invitacionesDocuments =
                          snapshot.data.documents;

               

                      return controller.invitacionesDocuments.isEmpty
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
                                      color: secondaryColor ),
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
                      if (!snapshot.hasData) return const Icon(Icons.contacts);

                      controller.solicitudesAEDocuments =
                          snapshot.data.documents;
                      

                      return controller.solicitudesAEDocuments.isEmpty
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
                                      color: secondaryColor),
                                )
                              ],
                            );
                    }),
                title: Text('Amigos'),
              ),
              BottomNavigationBarItem(
                icon: StreamBuilder(
                    stream: Firestore.instance
                        .collection('usuarios')
                        .where('amigos',
                            arrayContains: controller.usuario.usuario)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Icon(Icons.person);

                      controller.amigosDocuments =
                          snapshot.data.documents;
                      myFuture = checkIfMessage(controller.amigosDocuments, controller);
                      return FutureBuilder(
                          future: myFuture,
                          builder: (context, snap) {
                            if (!snap.hasData) return Icon(Icons.chat);
                            return snap.data
                                ? Icon(Icons.chat)
                                : Stack(
                                    children: <Widget>[
                                      Container(
                                          child: Icon(
                                            Icons.chat,
                                          ),
                                          width: 30,
                                          height: 30),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(right: 20),
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: secondaryColor),
                                      )
                                    ],
                                  );
                          });
                    }),
                title: Text('Chats'),
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
            title: Text(
              '¡Compra exitosa!',
              style: TextStyle(fontSize: 20),
            ),
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
            title: Text(
              'Error',
              style: TextStyle(fontSize: 20),
            ),
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

void _setEventListeners(Ads appAds, Controller controller, BuildContext context){



 

 

 

 

  appAds.video.loadedListener = () {
    print("An ad has loaded in memory.");
  };

  appAds.video.failedListener = () {
    print("An ad has failed to load in memory.");
  };

  appAds.video.clickedListener = () {
    print("An ad has been clicked on.");
  };

  appAds.video.openedListener = () {
    print("An ad has been opened.");
  };

  appAds.video.leftAppListener = () {
    print("You've left the app to view the video.");
  };

  appAds.video.closedListener = () {
    print("The video has been closed.");
  };

  appAds.video.rewardedListener = (String rewardType, int rewardAmount) {
    print("The ad was sent a reward amount.");
    deliverFreeCoins('2', controller, context);
   
  };

  appAds.video.startedListener = () {
    print("You've just started playing the Video ad.");
  };

  appAds.video.completedListener = () {
    print("You've just finished playing the Video ad.");
  };

  List<String> two = appAds.keywords;
  String three = appAds.contentUrl;
  bool seven = appAds.childDirected;
  List<String> eight = appAds.testDevices;
  print(two);
}

  void deliverFreeCoins(String cantidad, Controller controller, BuildContext context) async {
    
    var result = await controller.buyCoins(int.parse(cantidad));
    if (result) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text(
              '¡Gracias!',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
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
            title: Text(
              'Error',
              style: TextStyle(fontSize: 20),
            ),
            content: Text('Error'),
          ));
    }
  }
