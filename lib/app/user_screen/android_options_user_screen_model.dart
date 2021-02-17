import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:missionout/core/platforms.dart';

class AndroidOptionsUserScreenModel {
  static const _platform =
  MethodChannel('missionout.beaterboofs.com/criticalAlertsEntitlement');
  final _log = Logger("IOSOptionsUserScreenModel");

  AndroidOptionsUserScreenModel():assert(isAndroid);

  Future _goToAndroidAppSettings() async{
    _log.info("Requesting permission for critical alerts");
    try {
      final int result =
      await _platform.invokeMethod("requestCriticalAlertEntitlement");
      _log.info("Here my result: $result");
    } on PlatformException catch (e) {
      _log.warning("Failed to set Android critical alert entitlement: $e");
    }
  }
}