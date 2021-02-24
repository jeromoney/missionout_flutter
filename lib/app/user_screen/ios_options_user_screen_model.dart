import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

class IOSOptionsUserScreenModel {
  final _log = Logger("IOSOptionsUserScreenModel");

  static const _platform =
      MethodChannel('missionout.beaterboofs.com/criticalAlertsEntitlement');
  final BuildContext context;
  final User user;

  IOSOptionsUserScreenModel(this.context)
      : assert(Theme.of(context).platform == TargetPlatform.iOS),
        user = context.read<User>();

  // ignore: missing_return
  static Future<int> getCriticalAlertStatus() async {
    final log = Logger("IOSOptionsUserScreenModel");
    try {
      final result =
          await _platform.invokeMethod("getCriticalAlertStatus") as int;
      log.info("Here my critical alert result: $result");
      return result;
    } on PlatformException catch (e) {
      log.warning("Failed to get Critical Alert Status: $e");
    }
  }

  Future _requestCriticalAlertsIOS() async {
    _log.info("Requesting permission for critical alerts");
    try {
      final result =
          await _platform.invokeMethod("requestCriticalAlertEntitlement");
      _log.info("My critical alert entitlement: $result");
    } on PlatformException catch (e) {
      _log.warning("Failed to set IOS critical alert entitlement: $e");
    }
  }

  Future toggleCriticalAlerts({@required bool enable}) async {
    user.enableIOSCriticalAlerts = enable;
    if (enable) {
      _requestCriticalAlertsIOS();
    }
  }

  set iOSCriticalAlertsVolume(double volume) =>
      user.iOSCriticalAlertsVolume = volume;
  double get iOSCriticalAlertsVolume => user.iOSCriticalAlertsVolume;

  set iOSSound(String iOSSound) =>
      user.iOSSound = iOSSound;
  String get iOSSound => user.iOSSound;

  set enableIOSCriticalAlerts(bool enableIOSCriticalAlerts) =>
      user.enableIOSCriticalAlerts = enableIOSCriticalAlerts;
  bool get enableIOSCriticalAlerts => user.enableIOSCriticalAlerts;
}
