import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logging/logging.dart';
import 'package:missionout/communication/communication_plugin.dart';

class FirebaseCloudMessagingCommunicationPlugin extends CommunicationPlugin {
  @override
  // ignore: missing_return
  Future init() {
    final logger = Logger("firebaseCloudMessagingInit");
    final firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          logger.info("onMessage $message");
        },
        onResume: (Map<String, dynamic> message) async {
          logger.info("onResume $message");
        },
        onBackgroundMessage: _onBackgroundMessage,
        onLaunch: (Map<String, dynamic> message) async {
          logger.info("onBackgroundMessage $message");
        });

    // iOS only
    firebaseMessaging.requestNotificationPermissions();
  }

  static Future _onBackgroundMessage(Map<String, dynamic> message) async {
    Logger("FlutterLocalNotificationsInitializer")
        .info("onBackgroundMessage $message");
  }
}
