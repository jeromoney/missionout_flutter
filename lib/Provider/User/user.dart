import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

abstract class User with ChangeNotifier {
  bool isEditor;
  String teamID;
  PhoneNumber voicePhoneNumber;
  PhoneNumber mobilePhoneNumber;
  String region;
  String currentMission;

  String get uid;

  updatePhoneNumbers(
      {@required PhoneNumber mobilePhoneNumberVal,
        @required PhoneNumber voicePhoneNumberVal}) async {}
}
