import 'dart:async';

import 'package:flutter/material.dart';
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
      : team = context.watch<Team>(),
        user = context.watch<User>(),
        phoneInputStreamController =
            context.watch<StreamController<bool>>();

  Stream<List<PhoneNumberRecord>> get phoneNumbers => user.fetchPhoneNumbers();

  String get displayName => user.displayName ?? '';

  Future removePhoneNumberRecord(PhoneNumberRecord phoneNumberRecord) async {
    await user.deletePhoneNumber(phoneNumberRecord);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Deleted phone number")));
  }

  Future addPhoneNumber(PhoneNumberRecord phoneNumberRecord) async {
    await user.addPhoneNumber(phoneNumberRecord);
  }

  Future updateName(String displayName) async =>
      user.updateDisplayName(displayName: displayName);

  String validateName(String value) {
    if (value == "" || value == null) return "Name required";
  }

  void showPhoneInput() => phoneInputStreamController.add(true);
}
