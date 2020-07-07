import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:logging/logging.dart';

import 'package:missionout/services/user/user.dart';
const RETRY_COUNT = 5;
const RETRY_WAIT = 3; // seconds
class MyFirebaseUser implements User {

  @override
  final String uid;
  @override
  final String email;
  @override
  final String photoUrl;
  @override
  String displayName;

  // Values held in Firestore
  @override
  final String teamID;
  @override
  final bool isEditor;
  @override
  PhoneNumber voicePhoneNumber;
  @override
  PhoneNumber mobilePhoneNumber;

  // Implementation specific variables
  final Firestore _db = Firestore.instance;
  final _log = Logger('MyFirebaseUser');

  static Future<DocumentSnapshot> getOOOL(FirebaseUser firebaseUser) async {
    final log = Logger('MyFirebaseUser');
    final Firestore db = Firestore.instance;

    DocumentSnapshot snapshot;
    for (var i = 1; i < RETRY_COUNT; i++) {
      snapshot = await db
          .collection('users')
          .document(firebaseUser.uid)
          .get()
          .catchError((error) {
        log.warning("Error retrieving user info from firestore", error);
        return null;
      });
      if (snapshot.data == null)
        log.warning(
            "Race condition where the backend hasn't created the user account yet. Trying again");
      else
        break;
      await Future.delayed(Duration(seconds: RETRY_WAIT));
    }

    final data = snapshot.data as Map<String, dynamic>;

    if (data == null) {
      log.warning("Retries failed. Document still null");
      return null;
    }
  }

  @override
  MyFirebaseUser(
      {@required this.uid,
      @required this.email,
      this.photoUrl,
      this.displayName,
      @required this.teamID,
      @required this.isEditor,
      this.voicePhoneNumber,
      this.mobilePhoneNumber}) {
    addTokenToFirestore();
  }

  @override
  Future updatePhoneNumber(
      {@required PhoneNumber phoneNumber,
      @required PhoneNumberType type}) async {
    type == PhoneNumberType.mobile
        ? mobilePhoneNumber = phoneNumber
        : voicePhoneNumber = phoneNumber;
    await _db.document('users/$uid').updateData({
      (type == PhoneNumberType.mobile
          ? 'mobilePhoneNumber'
          : 'voicePhoneNumber'): {
        'isoCode': phoneNumber.isoCode,
        'phoneNumber': phoneNumber.phoneNumber
      },
    });
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<void> addTokenToFirestore() async {
    // Setting up the user will be the responsibility of the server.
    // This method adds the user token to firestore
    final fcmToken = await _firebaseMessaging.getToken();
    await _db.collection('users').document(this.uid).updateData({
      'tokens': FieldValue.arrayUnion([fcmToken])
    }).then((value) {
      _log.info('Added token to user document: $fcmToken', fcmToken);
    }).catchError((error) {
      _log.warning('Error adding token to user document', error);
    });
  }

  @override
  Future updateDisplayName({@required String displayName}) async {
    await _db.document('users/$uid').updateData({'displayName': displayName});
    this.displayName = displayName;
  }

}
