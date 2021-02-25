import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:missionout/services/communication_plugin/communication_plugin.dart';
import 'package:missionout/constants/strings.dart';

class FlutterLocalNotificationsCommunicationPlugin {

  FlutterLocalNotificationsCommunicationPlugin(){
    init();
  }


  Future init() async {
    final log = Logger("FlutterLocalNotificationsInitializer");
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    log.info("Received FCM: ${details.payload}");
    log.info(
        "Was app opened by notification: ${details.didNotificationLaunchApp}");
    // Initialize receiving FCM messages

    // android only
    await _initializeAndroidChannel();

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

  static Future _initializeAndroidChannel() async {
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


  static void displayNotification(RemoteNotification notification) {
    const androidNotificationDetails = AndroidNotificationDetails(
        'mission_pages_in_app',
        'Softer Mission Pages',
        'Pages received while app is open',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails(
          presentAlert: true,
          presentSound: true,
          presentBadge: false,
        );

    const notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      notificationDetails,
    );
  }
}
