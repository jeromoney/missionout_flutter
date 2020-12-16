import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMMessage {
  final String title;
  final String body;

  const FCMMessage({@required this.title, @required this.body});

  factory FCMMessage.fromMessage(RemoteNotification message) => FCMMessage(
      title: message.title,
      body: message.body,
    );
}
