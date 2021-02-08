import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:missionout/app/user_edit_screen/user_edit_screen.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/core/platforms.dart';
import 'package:missionout/data_objects/phone_number_record.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

class UserScreenModel {
  final _logger = Logger("UserScreenModel");
  final BuildContext context;
  final Team team;
  final User user;

  static const _platform =
      MethodChannel('missionout.beaterboofs.com/criticalAlertsEntitlement');

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
    if (isAndroid) {
      return true;
    }
    if (isIOS) {
      return true;
    }
    return false;
  }

  void displayDNDInfoText() {
    if (isWeb) {
      return;
    }
    if (isIOS) {
      PlatformAlertDialog(
        defaultActionText: Strings.ok,
        title: Strings.iOSDNDTitle,
        content: Strings.iOSDNDInfo,
      ).show(context);
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

  // ignore: non_constant_identifier_names
  Future DNDButtonAction() async {
    if (isIOS) {
      await _allowIos();
      return;
    }
    if (isAndroid) {
      await _goToAndroidAppSettings();
      return;
    }
    return;
  }
  
  Future _goToAndroidAppSettings() async{
    _logger.info("Requesting permission for critical alerts");
    try {
      final int result =
      await _platform.invokeMethod("requestCriticalAlertEntitlement");
      _logger.info("Here my result: $result");
    } on PlatformException catch (e) {
      _logger.warning("Failed to set Android critical alert entitlement: $e");
    }
  }

  Future _allowIos() async {
    _logger.info("Requesting permission for critical alerts");
    try {
      final int result =
          await _platform.invokeMethod("requestCriticalAlertEntitlement");
      _logger.info("Here my result: $result");
    } on PlatformException catch (e) {
      _logger.warning("Failed to set IOS critical alert entitlement: $e");
    }
  }
}
