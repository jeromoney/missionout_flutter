import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_cloud_messaging_communication_plugin.dart';

abstract class CommunicationPlugin {
  Future init();

  Future signOut();

  // returns a token and the field in firestore in which to place the token
  Future<TokenHolder> getToken();
}

class CommunicationPluginHolder {
  final _controller = StreamController<RemoteMessage>();

  Stream<RemoteMessage> get remoteMessageStream => _controller.stream;
  List<CommunicationPlugin> plugins;

  CommunicationPluginHolder() {
    plugins = [
      FirebaseCloudMessagingCommunicationPlugin(parentHolder: this),
    ];
  }

  void pushRemoteMessage(RemoteMessage message) => _controller.sink.add(message);
}

class TokenHolder{
  final String token;
  final String tokenList;
  TokenHolder({@required this.token,@required this.tokenList});
}
