import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/data_objects/phone_number_record.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

class UserEditScreenModel {
  final BuildContext context;
  final Team team;
  final User user;
  final StreamController<bool> phoneInputStreamController;

  UserEditScreenModel(this.context)
      : this.team = context.watch<Team>(),
        this.user = context.watch<User>(),
        this.phoneInputStreamController =
            context.watch<StreamController<bool>>();

  Future<List<PhoneNumberRecord>> get phoneNumbers async =>
      user.fetchPhoneNumbers().first;

  String get displayName => user.displayName ?? Strings.anonymousName;

  Future<List<PhoneNumberRecord>> removePhoneNumberRecord(
      PhoneNumberRecord phoneNumberRecord) async {
    await user.deletePhoneNumber(phoneNumberRecord);
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text("Deleted phone number")));
  }

  Future<PhoneNumberRecord> addPhoneNumber(
      PhoneNumberRecord phoneNumberRecord) async {
    final boogs = 1000000000 + Random().nextInt(4000000000);
    final phoneNumberRecord = PhoneNumberRecord(
      uid: user.uid,
      isoCode: "US",
      phoneNumber: "+1${boogs.toString()}",
      allowText: true,
      allowCalls: false,
    );
    await user.addPhoneNumber(phoneNumberRecord);
    return phoneNumberRecord;
  }

  Future updateName(String displayName) async =>
      await user.updateDisplayName(displayName: displayName);

  validateName(String value) {
    if (value == "" || value == null) return "Name required";
  }

  showPhoneInput() => phoneInputStreamController.add(true);

  hidePhoneInput() => phoneInputStreamController.add(false);
}
