import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:missionout/core/global_navigator_key.dart';
import 'package:missionout/data_objects/fcm_message.dart';
import 'package:provider/provider.dart';

class FCMMessageHandler {
  final _log = Logger('FCMMessageHandler');

  FCMMessageHandler() {
    _initState();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _initState() {
    _firebaseMessaging.requestPermission();
    initializeAndroidChannel();
    FirebaseMessaging.onBackgroundMessage(FCMMessageHandler.pageMissionAlert);

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_logo');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen(pageMissionAlert);
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   final String missionDocumentPath = message.data["missionDocumentPath"];
    // });
  }

  static Future pageMissionAlert(RemoteMessage remoteMessage) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'mission_pages',
      'Mission Pages',
      'This channel is used to page out missions.',
      sound: RawResourceAndroidNotificationSound('school_fire_alarm'),
      importance: Importance.max,
      priority: Priority.max,
    );
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(
            sound: 'school_fire_alarm.m4a',
            presentSound: true,
            presentAlert: true);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final notification = FCMMessage.fromMessage(remoteMessage.notification);
    // await flutterLocalNotificationsPlugin.show(
    //     0, "I am here"+ notification.title, notification.body, platformChannelSpecifics,
    //     payload: remoteMessage?.data["missionDocumentPath"]);
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
