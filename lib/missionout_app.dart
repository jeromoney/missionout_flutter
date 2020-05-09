import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'UI/EditorScreen/editor_screen.dart';
import 'UI/UserScreen/user_screen.dart';
import 'UI/overview_screen.dart';

class MissionOutApp extends StatefulWidget {
  // Called once all of the providers have been setup
  @override
  State<MissionOutApp> createState() => MissionOutAppState();
}

class MissionOutAppState extends State<MissionOutApp> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      debugPrint(token);
    });
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        debugPrint("Received onLaunch message");
      },
      onMessage: (Map<String, dynamic> message) async {
        debugPrint("Received onMessage message");
        // find scaffold in tree
        try {
          // Android is receiving a data message, different than iOS for some reason.
          if (Platform.isAndroid) message = message["data"].cast<String,dynamic>();
          final alertDialog = AlertDialog(
            title: Text("Update: ${message["description"] ?? ""}"),
            content: Text(message["needForAction"] ?? ""),
          );
          showDialog(context: context, child: alertDialog);
        } catch (e) {
          debugPrint(e.toString());
        }
      },
      onResume: (Map<String, dynamic> message) async {
        debugPrint("Received onResume message");
        debugPrint(message.toString());
        var iOSPlatformChannelSpecifics = IOSNotificationDetails(
            presentSound: true, sound: "school_fire_alarm.m4a");
        var platformChannelSpecifics =
            NotificationDetails(null, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(0, message["description"],
            message["needForAction"], platformChannelSpecifics,
            payload: 'item x');
      },
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Mission Out',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        darkTheme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (context) => OverviewScreen(),
          '/editor_options': (context) => EditorScreen(),
          '/user_options': (context) => UserScreen()
        },
      );
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  // Or do other work.
}
