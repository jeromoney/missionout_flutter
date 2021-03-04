import 'dart:async';

import 'package:flutter/material.dart';
import 'package:missionout/data_objects/phone_number_record.dart';
import 'package:missionout/services/user/user.dart';

class MockUser implements User {
  final _phoneNumberStreamController = StreamController<List<PhoneNumberRecord>>();
  
  final List<PhoneNumberRecord> _phoneNumberRecords = [
     const PhoneNumberRecord(
        uid: "a1242",
        isoCode: "+1",
        allowText: true,
        phoneNumber: "7195551234",
        allowCalls: false),
    const PhoneNumberRecord(
        uid: "a1242",
        isoCode: "+1",
        allowText: true,
        phoneNumber: "+15105551234",
        allowCalls: false)
  ];

  @override
  // ignore: missing_return
  Future addPhoneNumber(PhoneNumberRecord phoneNumberRecord) {
    _phoneNumberRecords.add(phoneNumberRecord);
    _phoneNumberStreamController.add(_phoneNumberRecords);
  }

  @override
  // ignore: missing_return
  Future deletePhoneNumber(PhoneNumberRecord phoneNumberRecord) {
    _phoneNumberRecords.remove(phoneNumberRecord);
    _phoneNumberStreamController.add(_phoneNumberRecords);
  }

  @override
  Stream<List<PhoneNumberRecord>> fetchPhoneNumbers() {
    _phoneNumberStreamController.add(_phoneNumberRecords);
    return _phoneNumberStreamController.stream;
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
  bool get isEditor => true;

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
