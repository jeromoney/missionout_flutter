import 'package:flutter/material.dart';
import 'package:missionout/app/user_edit_screen/user_edit_screen.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/data_objects/phone_number_record.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

class UserScreenModel {
  final BuildContext context;
  final Team team;
  final User user;

  Stream<List<PhoneNumberRecord>> get phoneNumbers => user.fetchPhoneNumbers();

  String get teamName => team.teamID;

  String get displayName => user.displayName ?? Strings.anonymousName;

  String get email => user.email ?? Strings.anonymousEmail;

  UserScreenModel(this.context)
      : this.team = context.watch<Team>(),
        this.user = context.watch<User>();

  editUserOptions() => Navigator.pushNamed(context, UserEditScreen.routeName);
}
