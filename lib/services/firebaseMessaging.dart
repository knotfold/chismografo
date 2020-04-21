import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class FirebaseMessage extends StatefulWidget {
  @override
  _FirebaseMessagingState createState() => _FirebaseMessagingState();
}

class _FirebaseMessagingState extends State<FirebaseMessage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    

    _firebaseMessaging.configure(
        onResume: (Map<String, dynamic> message) async {},
        onLaunch: (Map<String, dynamic> message) async {},
        onMessage: (Map<String, dynamic> message) async {});

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(alert: true, badge: true, sound: true));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
