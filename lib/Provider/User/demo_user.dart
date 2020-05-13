import 'package:flutter/material.dart';
import 'package:missionout/Provider/User/user.dart';

class DemoUser with ChangeNotifier implements User {
  DemoUser() {
    notifyListeners();
  }

  @override
  bool isEditor = true;

  @override
  String mobilePhoneNumber = "+1-212-555-1234";

  @override
  String region = "US";

  @override
  String teamID;

  @override
  String voicePhoneNumber = "1-212-555-4321";

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
  Future<void> updatePhoneNumbers(
      {String mobilePhoneNumber, String voicePhoneNumber}) {
    // TODO: implement updatePhoneNumbers
    return null;
  }

  @override
  String currentMission;
}
