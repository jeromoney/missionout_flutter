import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/data_objects/fcm_message.dart';
import 'package:missionout/main.dart';

class FCMMessageHandler extends StatefulWidget {
  final _log = Logger('FCMMessageHandler');
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
      widget._log.info("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      widget._log.info('Accessed FCM token', token);
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        widget._log.info("Received onMessage message");
        final notification = FCMMessage(message);
        PlatformAlertDialog(
          title: "Update: ${notification.title}",
          content: notification.body,
          defaultActionText: Strings.ok,).show(
            MyApp.navKey.currentState.overlay.context);
      },
      onResume: (Map<String, dynamic> message) async {
        widget._log.info("Received onResume message");
        widget._log.info(message);
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
