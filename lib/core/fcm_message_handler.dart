import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:missionout/DataLayer/fcm_message.dart';

class FCMMessageHandler extends StatefulWidget {
  final Widget child;

  FCMMessageHandler({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  State createState() => _FCMMessageHandlerState(child: child);
}

class _FCMMessageHandlerState extends State<FCMMessageHandler> {
  Widget child;

  _FCMMessageHandlerState({
    this.child,
  });

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

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
      onMessage: (Map<String, dynamic> message) async {
        debugPrint("Received onMessage message");
        final notification = FCMMessage(message);
        final alertDialog = AlertDialog(
          title: Text("Update: ${notification.title}"),
          content: Text(notification.body),
        );
        showDialog(context: context, child: alertDialog);
      },
      onResume: (Map<String, dynamic> message) async {
        debugPrint("Received onResume message");
        debugPrint(message.toString());
        // Android notifications are handled in java code
        var iOSPlatformChannelSpecifics = IOSNotificationDetails(
            presentSound: true, sound: "school_fire_alarm.m4a");
        var platformChannelSpecifics =
            NotificationDetails(null, iOSPlatformChannelSpecifics);
        await _flutterLocalNotificationsPlugin.show(0, message["description"],
            message["needForAction"], platformChannelSpecifics);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
