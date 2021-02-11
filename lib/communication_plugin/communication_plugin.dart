import 'firebase_cloud_messaging_communication_plugin.dart';
import 'firebase_communication_plugin.dart';
import 'flutter_local_notifications_communication_plugin.dart';

abstract class CommunicationPlugin{
 Future init();
 Future signOut();
}

final List<CommunicationPlugin> communicationPlugins = [
 FirebaseCloudMessagingCommunicationPlugin(),
 FirebaseCommunicationPlugin(),
 FlutterLocalNotificationsCommunicationPlugin()
];