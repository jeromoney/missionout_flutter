import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:missionout/constants/strings.dart';

class FCMMessageHandler {
  final _logger = Logger("FCMMessageHandler");

  FCMMessageHandler() {
    _initState();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void _initState() {
    _firebaseMessaging.requestNotificationPermissions();
    initializeAndroidChannel();

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

  static Future initializeAndroidChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        Strings.channelId, // id
        Strings.channelName, // title
        Strings.channelDescription, // description
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound(
            "school_fire_alarm")); //This is where the sound is set in android

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
