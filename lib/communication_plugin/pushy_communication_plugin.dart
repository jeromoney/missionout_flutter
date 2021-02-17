import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:missionout/communication_plugin/communication_plugin.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

import 'flutter_local_notifications_communication_plugin.dart';

class PushyCommunicationPlugin extends CommunicationPlugin {
  @override
  Future init() {
    // TODO: implement init
  }

  @override
  Future signOut() {
    // TODO: implement signOut
  }

  // Please place this code in main.dart,
  // After the import statements, and outside any Widget class (top-level)

  static void backgroundNotificationListener(Map<String, dynamic> data) {
// Print notification payload data
    print('Received notification: $data');
// Notification title
    const notificationTitle = 'MyApp';
// Attempt to extract the "message" property from the payload: {"message":"Hello World!"}
    final String notificationText = data['message'] as String ?? 'Hello World!';
// Android: Displays a system notification
    final notification =
        RemoteNotification(title: data.toString(), body: "dfdf");
    FlutterLocalNotificationsCommunicationPlugin.displayNotification(
        notification);
// iOS: Displays an alert dialog
    Pushy.notify(notificationTitle, notificationText, data);
// Clear iOS app badge number
    Pushy.clearBadge();
  }
}
