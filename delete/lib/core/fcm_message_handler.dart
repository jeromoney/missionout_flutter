import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/data_objects/fcm_message.dart';
import 'package:provider/provider.dart';

import 'global_navigator_key.dart';

class FCMMessageHandler {
  final _log = Logger('FCMMessageHandler');
  final BuildContext context;

  FCMMessageHandler({@required this.context}) {
    _initState();
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void _initState() {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      _log.info("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      _log.info('Accessed FCM token', token);
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        final navKey = context.read<GlobalNavigatorKey>().navKey;
        _log.info("Received onMessage message");
        final notification = FCMMessage.fromMessage(message);
        PlatformAlertDialog(
          title: "Update: ${notification.title}",
          content: notification.body,
          defaultActionText: Strings.ok,
        ).show(navKey.currentState.overlay.context);
      },
      onResume: (Map<String, dynamic> message) async {
        _log.info("Received onResume message");
        _log.info(message);
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
}
