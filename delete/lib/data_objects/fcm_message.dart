import 'dart:io';

import 'package:flutter/material.dart';

class FCMMessage {
  final String title;
  final String body;

  FCMMessage({@required this.title, @required this.body});

  factory FCMMessage.fromMessage(Map<String, dynamic> message) {
    String title;
    String body;
    if (Platform.isIOS || Platform.isMacOS) {
      title = message["aps"]["alert"]["title"] ??
          ArgumentError(
              "Expected json format for iOS of form [\"aps\"][\"alert\"][\"title\"] ");
      body = message["aps"]["alert"]["body"] ?? "";
    } else if (Platform.isAndroid) {
      title = message["notification"]["title"] ??
          ArgumentError(
              "Expected json format for Android of form [\"notification\"][\"title\"] ");
      body = message["notification"]["body"] ?? "";
    }
    return FCMMessage(
      title: title,
      body: body,
    );
  }
}
