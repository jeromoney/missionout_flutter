import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/overview_screen.dart';
import 'package:missionout/UI/signin_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isLoggedIn = false;

  @override
  void initState(){
    super.initState();
    if (!Platform.isIOS){
      // Notifications for Android are handled in MainActivity.kt
      return;
    }
    
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
      AlertDialog alert = AlertDialog(title: Text(message.toString()),);
      showDialog(context: context, child: alert);

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
      return OverviewScreen();
    } else {
      return SigninScreen();
    }
  }
}
