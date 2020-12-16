import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void _initState() {
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      _log.info('Accessed FCM token', token);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
      final navKey = context.read<GlobalNavigatorKey>().navKey;
      _log.info("Received onMessage message");
      final notification = FCMMessage.fromMessage(remoteMessage.notification);
      PlatformAlertDialog(
        title: notification.title,
        content: notification.body,
        defaultActionText: Strings.ok,
      ).show(navKey.currentState.overlay.context);
    });
  }

  static initializeAndroidChannel() async {
    const MethodChannel platform =
    MethodChannel('beaterboofs/missionout');
    final String alarmUri = await platform.invokeMethod('getAlarmUri');
    final UriAndroidNotificationSound uriSound =
    UriAndroidNotificationSound(alarmUri);

     final AndroidNotificationChannel channel = AndroidNotificationChannel(
        'mission_pages', // id
        'Mission Pages', // title
        'This channel is used to page out missions.', // description
        importance: Importance.max, playSound: true, sound: UriAndroidNotificationSound("android.resource://beaterboofs/raw/school_fire_alarm.mp3"
     )
    );

     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
     FlutterLocalNotificationsPlugin();
     await flutterLocalNotificationsPlugin
         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
         ?.createNotificationChannel(channel);
  }
}

