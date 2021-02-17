import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:missionout/core/platforms.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

class IOSOptionsUserScreenModel {
  final _log = Logger("IOSOptionsUserScreenModel");

  static const _platform =
      MethodChannel('missionout.beaterboofs.com/criticalAlertsEntitlement');
  final BuildContext context;
  final User user;

  IOSOptionsUserScreenModel(this.context)
      : assert(isIOS),
        user = context.watch<User>();

  // ignore: missing_return
  static Future<int> getCriticalAlertStatus() async {
    final log = Logger("IOSOptionsUserScreenModel");
    assert(isIOS);
    try {
      final result =
          await _platform.invokeMethod("getCriticalAlertStatus") as int;
      log.info("Here my critical alert result: $result");
      return result;
    } on PlatformException catch (e) {
      log.warning("Failed to get Critical Alert Status: $e");
    }
  }

  Future requestCriticalAlertsIOS() async {
    assert(isIOS);
    _log.info("Requesting permission for critical alerts");
    try {
      final int result =
          await _platform.invokeMethod("requestCriticalAlertEntitlement");
      _log.info("Here my result: $result");
    } on PlatformException catch (e) {
      _log.warning("Failed to set IOS critical alert entitlement: $e");
    }
  }

  Future toggleCriticalAlerts({@required bool enable}) async {
    await user.setEnableIOSCriticalAlerts(enable: enable);
    if (enable) {
      requestCriticalAlertsIOS();
    }
  }

  Future setIOSCriticalAlertsVolume({@required double volume}) {
    user.setIOSCriticalAlertsVolume(volume: volume);
  }

  static User getUserStatic(BuildContext context) => context.read<User>();
}
