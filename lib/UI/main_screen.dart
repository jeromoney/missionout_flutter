import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/overview_screen.dart';
import 'package:missionout/UI/signin_screen.dart';
import 'package:provider/provider.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isLoggedIn = false;

  @override
  void initState(){
    super.initState();
//    if (!Platform.isIOS){
//      // Notifications for Android are handled in MainActivity.kt
//      //return;
//    }
    
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions(
      // Not choosing provisional for now so user either gets full notifications or none
      const IosNotificationSettings(sound: true,alert: true,badge: true,provisional: false)
    );
    _firebaseMessaging.getToken().then((String token){
      assert(token!=null);
      debugPrint(token);
    });
    _firebaseMessaging.configure(
    onLaunch: (Map<String,dynamic> message) async {
      debugPrint("Receieved launch message");
    },
    onMessage: (Map<String,dynamic> message) async {
      debugPrint("Receieved message");
      // TODO - play an alert sound here
      _showDialog(context);

    },
    onResume: (Map<String,dynamic> message) async {
      debugPrint("Receieved resume message");
    },);

  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    isLoggedIn = user.isLoggedIn;
    if (isLoggedIn) {
      //_showDialog(context);
      return OverviewScreen();
    } else {
      return SigninScreen();
    }
  }
}

void _showDialog(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Alert Dialog title"),
        content: new Text("Alert Dialog body"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    debugPrint("Received background data message");
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    debugPrint("Received background notification");

  }

  // Or do other work.
}