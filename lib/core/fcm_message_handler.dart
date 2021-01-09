import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:missionout/data_objects/fcm_message.dart';

class FCMMessageHandler {
  final _log = Logger('FCMMessageHandler');

  FCMMessageHandler() {
    _initState();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _initState() {
    _firebaseMessaging.requestPermission();
    initializeAndroidChannel();
    FirebaseMessaging.onMessage.listen(pageMissionAlert);
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_logo');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
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

    await flutterLocalNotificationsPlugin.show(
        0,
        notification.title,
        notification.body,
        platformChannelSpecifics,
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
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description',
      sound: RawResourceAndroidNotificationSound('school_fire_alarm'),
    );
    RawResourceAndroidNotificationSound('school_fire_alarm').sound;
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
        0,
        'custom sound notification title',
        'custom sound notification body',
        platformChannelSpecifics);
  }
}
