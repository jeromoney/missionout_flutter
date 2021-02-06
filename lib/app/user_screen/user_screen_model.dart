import 'package:flutter/material.dart';
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

  void editUserOptions() =>
      Navigator.pushNamed(context, UserEditScreen.routeName);

  bool get isDNDOverridePossible {
    if (isWeb) {
      return false;
    }
    return true;
  }

  // ignore: avoid_positional_boolean_parameters
  Future doNotDisturbOverride(bool value) async {
    if (isWeb) {
      return;
    } else if (isAndroid) {
      return;
    } else if (isIOS) {}
  }

  void doNotDisturbTextBehavior() {
    if (isWeb) {
      return;
    }
    if (isIOS) {
      return;
    }
    if (isAndroid) {
      showDialog(
          context: context,
          barrierDismissible: true,
          child: const AlertDialog(
            title: Text(Strings.androidDNDInfoTitle),
            content: SingleChildScrollView(child: Text(Strings.androidDNDInfo)),
          ));
    }
  }
}
