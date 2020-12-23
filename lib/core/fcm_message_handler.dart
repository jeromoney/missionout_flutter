import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:missionout/data_objects/fcm_message.dart';

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
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_logo');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen(pageMissionAlert);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      throw UnimplementedError();
    });
  }

   static Future pageMissionAlert(RemoteMessage remoteMessage) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'mission_pages',
      'Mission Pages',
      'This channel is used to page out missions.',
      sound: RawResourceAndroidNotificationSound('school_fire_alarm'),
    );
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
    IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    const MacOSNotificationDetails macOSPlatformChannelSpecifics =
    MacOSNotificationDetails(sound: 'slow_spring_board.aiff');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
        macOS: macOSPlatformChannelSpecifics);
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final notification = FCMMessage.fromMessage(remoteMessage.notification);
    await flutterLocalNotificationsPlugin.show(
        0, notification.title, notification.body, platformChannelSpecifics,
        payload: remoteMessage?.data["missionDocumentPath"]);
  }

  static initializeAndroidChannel() async {
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
        'mission_pages', // id
        'Mission Pages', // title
        'This channel is used to page out missions.', // description
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound("school_fire_alarm"));

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
