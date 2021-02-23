import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

class AndroidOptionsUserScreenModel {
  final BuildContext context;
  static const _platform =
  MethodChannel('missionout.beaterboofs.com/criticalAlertsEntitlement');
  final _log = Logger("IOSOptionsUserScreenModel");

  AndroidOptionsUserScreenModel(this.context):assert(Theme.of(context).platform == TargetPlatform.android);

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