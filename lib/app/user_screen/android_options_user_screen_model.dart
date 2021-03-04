import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:missionout/services/communication_plugin/flutter_local_notifications_communication_plugin.dart';

class AndroidOptionsUserScreenModel {
  final androidSound = "Hello World";
  final BuildContext context;
  static const _platform =
  MethodChannel('missionout.beaterboofs.com/criticalAlertsEntitlement');
  final _log = Logger("IOSOptionsUserScreenModel");

  AndroidOptionsUserScreenModel(this.context):assert(Theme.of(context).platform == TargetPlatform.android);

  Future goToAndroidAppSettings() async{
    _log.info("Requesting permission for critical alerts");
    try {
      final int result =
      await _platform.invokeMethod("requestCriticalAlertEntitlement");
      _log.info("Here my result: $result");
    } on PlatformException catch (e) {
      _log.warning("Failed to set Android critical alert entitlement: $e");
    }
  }

  Future<void> setAlertSound(String alertSound) async {
    final _notificationsPlugin = FlutterLocalNotificationsCommunicationPlugin();
    await _notificationsPlugin.deleteNotificationChannel();
    await _notificationsPlugin.createNotificationChannel("voriko");
  }
}