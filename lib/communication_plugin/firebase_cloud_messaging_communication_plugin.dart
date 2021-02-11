import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:missionout/communication_plugin/communication_plugin.dart';
import 'package:missionout/core/platforms.dart';

class FirebaseCloudMessagingCommunicationPlugin extends CommunicationPlugin {
  final _logger = Logger("FirebaseCloudMessagingCommunicationPlugin");

  @override
  // ignore: missing_return
  Future init() {
    final firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          _logger.info("onMessage $message");
          FlutterRingtonePlayer.playNotification();
          Get.snackbar("notification title", message.toString());
        },
        onResume: (Map<String, dynamic> message) async {
          _logger.info("onResume $message");
        },
        onBackgroundMessage: _onBackgroundMessage,
        onLaunch: (Map<String, dynamic> message) async {
          _logger.info("onBackgroundMessage $message");
        });

    // iOS only
    firebaseMessaging.requestNotificationPermissions();
  }

  static Future _onBackgroundMessage(Map<String, dynamic> message) async {
    Logger("FlutterLocalNotificationsInitializer")
        .info("onBackgroundMessage $message");
  }

  @override
  Future signOut() async {
    // remove token from Firestore from first, before user signs out
    if (!isWeb) {
      final fcmToken = await FirebaseMessaging().getToken();
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
      db.collection('users').doc(_firebaseAuth.currentUser.uid).update({
        'tokens': FieldValue.arrayRemove([fcmToken])
      }).then((value) {
        _logger.info('Removed token to user document');
      }).catchError((error) {
        _logger.warning('Error removing token from user document', error);
      });
    }
  }
}
