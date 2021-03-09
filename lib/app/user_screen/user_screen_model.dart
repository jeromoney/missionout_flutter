import 'dart:async';

import 'package:flutter/material.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/data_objects/phone_number_record.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

class UserScreenModel {
  final BuildContext context;
  final Team team;
  final User user;
  final StreamController<bool> phoneInputStreamController;

  UserScreenModel(this.context)
      : team = context.watch<Team>(),
        user = context.watch<User>(),
        phoneInputStreamController =
        context.watch<StreamController<bool>>();

  Stream<List<PhoneNumberRecord>> get phoneNumbers => user.fetchPhoneNumbers();

  String get teamName => team.teamID;

  String get displayName => user.displayName ?? Strings.anonymousName;

  String get email => user.email ?? Strings.anonymousEmail;

  Future removePhoneNumberRecord(PhoneNumberRecord phoneNumberRecord) async {
    await user.deletePhoneNumber(phoneNumberRecord);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Deleted phone number")));
  }

  Future addPhoneNumber(PhoneNumberRecord phoneNumberRecord) async {
    await user.addPhoneNumber(phoneNumberRecord);
  }


  void showPhoneInput() => phoneInputStreamController.add(true);
}
