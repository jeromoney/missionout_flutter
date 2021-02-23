import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:missionout/services/communication_plugin/communication_plugin.dart';

class FirebaseCloudMessagingCommunicationPlugin extends CommunicationPlugin {
  final CommunicationPluginHolder parentHolder;

  final _logger = Logger("FirebaseCloudMessagingCommunicationPlugin");

  FirebaseCloudMessagingCommunicationPlugin({@required this.parentHolder}) {
    init();
  }

  @override
// ignore: missing_return
  Future init() {
    // iOS only
    FirebaseMessaging.instance.requestPermission();
  }

  static Future _onBackgroundMessage(Map<String, dynamic> message) async {
    Logger("FlutterLocalNotificationsInitializer")
        .info("onBackgroundMessage$message");
  }

  @override
  Future signOut() async {
    // remove token from Firestore from first, before user signs out
    //isWeb
    final fcmToken = await FirebaseMessaging.instance.getToken();
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
