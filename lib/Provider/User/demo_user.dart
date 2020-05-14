import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:missionout/Provider/User/user.dart';

class DemoUser with ChangeNotifier implements User {
  DemoUser() {
    notifyListeners();
  }

  @override
  bool isEditor = true;

  @override
  PhoneNumber mobilePhoneNumber = PhoneNumber(phoneNumber: "+12125551234",isoCode: "US");

  @override
  String region = "US";

  @override
  String teamID;

  @override
  PhoneNumber voicePhoneNumber = PhoneNumber(phoneNumber: "+12125554321",isoCode: "US");

  @override
  void addListener(listener) {
    super.addListener(listener);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get hasListeners => super.hasListeners;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }

  @override
  // TODO: implement uid
  String get uid => null;

  @override
  Future updatePhoneNumbers(
      {PhoneNumber mobilePhoneNumberVal, PhoneNumber voicePhoneNumberVal}) {
    mobilePhoneNumber = mobilePhoneNumberVal;
    voicePhoneNumber = voicePhoneNumberVal;
  }

  @override
  String currentMission;
}
