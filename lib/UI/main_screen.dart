import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState(){
    super.initState();
//    if (!Platform.isIOS){
//      // Notifications for Android are handled in MainActivity.kt
//      return;
//    }
    
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions(
      // Not choosing provisional for now so user either gets full notifications or none
      const IosNotificationSettings(sound: true,alert: true,badge: true,provisional: false)
    );
    _firebaseMessaging.getToken().then((String token){
      assert(token!=null);
      //debugPrint(token);
    });
    _firebaseMessaging.configure(
    onLaunch: (Map<String,dynamic> message) async {
      debugPrint("Receieved launch message");
    },
    onMessage: (Map<String,dynamic> message) async {
      debugPrint("Receieved message");
      // TODO - play an alert sound here
      AlertDialog alert = AlertDialog(title: Text(message["description"]),content: Text(message["needForAction"]),);
      showDialog(context: context, child: alert);

    },
    onResume: (Map<String,dynamic> message) async {
      debugPrint(message.toString());
        var iOSPlatformChannelSpecifics = IOSNotificationDetails(presentSound: true, sound: "school_fire_alarm.m4a");
        var platformChannelSpecifics = NotificationDetails(
            null, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0, message["description"], message["needForAction"], platformChannelSpecifics,
            payload: 'item x');

    },);

  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    switch(user.signInStatus) {
      case SignInStatus.signedIn:
        {
          return OverviewScreen();
        }
        break;
      case SignInStatus.signedOut: {
        return SigninScreen();
      }
      break;
      case SignInStatus.waiting: {
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      break;
    }
  }
}
