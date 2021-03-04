import 'package:flutter/src/widgets/framework.dart';
import 'package:missionout/data_objects/phone_number_record.dart';
import 'package:missionout/services/user/user.dart';

class MockUser implements User{
  @override
  Future addPhoneNumber(PhoneNumberRecord phoneNumberRecord) {
    // TODO: implement addPhoneNumber
    throw UnimplementedError();
  }

  @override
  Future deletePhoneNumber(PhoneNumberRecord phoneNumberRecord) {
    // TODO: implement deletePhoneNumber
    throw UnimplementedError();
  }

  @override
  Stream<List<PhoneNumberRecord>> fetchPhoneNumbers() => null;

  @override
  Future<bool> setEnableIOSCriticalAlerts({bool enable}) {
    // TODO: implement setEnableIOSCriticalAlerts
    throw UnimplementedError();
  }

  @override
  Future setIOSCriticalAlertsVolume({double volume}) {
    // TODO: implement setIOSCriticalAlertsVolume
    throw UnimplementedError();
  }

  @override
  Future setIOSSound(String alertSound) {
    // TODO: implement setIOSSound
    throw UnimplementedError();
  }

  @override
  void updateDisplayName({String displayName}) {
    this.displayName = displayName;
  }

  @override
  void updatePhoneNumber({PhoneNumber phoneNumber, PhoneType type}) {
    // TODO: implement updatePhoneNumber
  }

  @override
  bool enableIOSCriticalAlerts = false;

  @override
  double iOSCriticalAlertsVolume = 1.0;

  @override
  String iOSSound;

  @override
  PhoneNumber mobilePhoneNumber;

  @override
  PhoneNumber voicePhoneNumber;

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  String displayName = "Joe Blow";



  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  // TODO: implement email
  String get email => "joe@example.com";

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  // TODO: implement isEditor
  bool get isEditor => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  // TODO: implement photoUrl
  String get photoUrl => null;

  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }

  @override
  // TODO: implement teamID
  String get teamID => throw UnimplementedError();

  @override
  // TODO: implement uid
  String get uid => "dfdfsfsf";

  @override
  BuildContext context;

}