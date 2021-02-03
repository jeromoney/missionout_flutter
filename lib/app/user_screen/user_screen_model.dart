import 'package:flutter/material.dart';
import 'package:flutter_dnd/flutter_dnd.dart';
import 'package:missionout/app/user_edit_screen/user_edit_screen.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/core/platforms.dart';
import 'package:missionout/data_objects/phone_number_record.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

class UserScreenModel {
  final BuildContext context;
  final Team team;
  final User user;


  UserScreenModel(this.context)
      : team = context.watch<Team>(),
        user = context.watch<User>();

  Stream<List<PhoneNumberRecord>> get phoneNumbers => user.fetchPhoneNumbers();

  String get teamName => team.teamID;

  String get displayName => user.displayName ?? Strings.anonymousName;

  String get email => user.email ?? Strings.anonymousEmail;


  void editUserOptions() => Navigator.pushNamed(context, UserEditScreen.routeName);

  // ignore: avoid_positional_boolean_parameters
  void doNotDisturbOverride(bool value) {
    if (isWeb){
      return;
    }
    else if (isAndroid){
      FlutterDnd.gotoPolicySettings();
    }
    else if (isIOS){

    }
  }
}
