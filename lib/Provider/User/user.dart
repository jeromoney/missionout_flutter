import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

abstract class User with ChangeNotifier {
  bool isEditor;
  String teamID;
  String voicePhoneNumber;
  String mobilePhoneNumber;
  String region;
  String currentMission;

  String get uid;

  updatePhoneNumbers(
      {@required String mobilePhoneNumberStr,
        @required String voicePhoneNumberStr}) async {}
}
