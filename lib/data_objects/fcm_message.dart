import 'dart:io';

class FCMMessage {
  String _title;
  String get title => _title;
  String _body;
  String get body => _body;

  FCMMessage(Map<String, dynamic> message) {
    if (Platform.isIOS || Platform.isMacOS) {
      _title = message["aps"]["alert"]["title"] ??
          ArgumentError("Expected json format for iOS of form [\"aps\"][\"alert\"][\"title\"] ");
      _body = message["aps"]["alert"]["body"] ?? "";

    }
    else if (Platform.isAndroid) {
      _title = message["notification"]["title"] ??
          ArgumentError("Expected json format for Android of form [\"notification\"][\"title\"] ");
      _body = message["notification"]["body"] ?? "";
    }
  }

}