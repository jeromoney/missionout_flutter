import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:missionout/data_objects/fcm_message.dart';

class FCMMessageHandler {
  FCMMessageHandler() {
    _initState();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void _initState() {
    _firebaseMessaging.requestPermission();
    initializeAndroidChannel();
    FirebaseMessaging.onMessage.listen(pageMissionAlert);
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_logo');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future pageMissionAlert(RemoteMessage remoteMessage) async {
    final log = Logger('FCMMessageHandler');

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
    log.info(
        "FCM Message payload is: ${remoteMessage?.data["missionDocumentPath"]}");
    await flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: remoteMessage?.data["missionDocumentPath"] as String,
    );
  }

  static Future initializeAndroidChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
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
