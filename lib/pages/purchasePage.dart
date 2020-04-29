import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trivia_form/shared/shared.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';


class PurchasePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            
          ],
        ),
      ),
    );
  }

  Future<bool> purchaseResult() async {
    
  }
}