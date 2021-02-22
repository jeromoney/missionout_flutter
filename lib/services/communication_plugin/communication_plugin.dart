import 'dart:async';

import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';

import 'firebase_cloud_messaging_communication_plugin.dart';
import 'flutter_local_notifications_communication_plugin.dart';
import 'pushy_communication_plugin.dart';

abstract class CommunicationPlugin {
  Future init();

  Future signOut();
}

class CommunicationPluginHolder {
  final _controller = StreamController<RemoteMessage>();

  Stream<RemoteMessage> get remoteMessageStream => _controller.stream;
  List<CommunicationPlugin> plugins;

  CommunicationPluginHolder() {
    plugins = [
      FirebaseCloudMessagingCommunicationPlugin(parentHolder: this),
      FlutterLocalNotificationsCommunicationPlugin(),
      PushyCommunicationPlugin(),
    ];
  }

  void pushRemoteMessage(RemoteMessage message) => _controller.sink.add(message);
}
