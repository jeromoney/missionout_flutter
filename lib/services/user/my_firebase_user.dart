import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:logging/logging.dart';
import 'package:firestore_annotations/firestore_annotations.dart';

import 'package:missionout/services/user/user.dart';

part 'my_firebase_user.g.dart';

const RETRY_COUNT = 5;
const RETRY_WAIT = 3; // seconds

@FirestoreDocument(hasSelfRef: false)
class MyFirebaseUser implements User {
  // Values from FirebaseUser
  FirebaseUser _firebaseUser;

  @override
  String get uid => _firebaseUser.uid;

  @override
  String get email => _firebaseUser.email;

  @override
  String get photoUrl => _firebaseUser.photoUrl;

  @override
  String get displayName => _firebaseUser.displayName ?? firestoreDisplayName;

  String firestoreDisplayName;

  // Values held in Firestore
  @override
  final String teamID;
  @override
  final bool isEditor;
  @override
  @FirestoreAttribute(ignore: true)
  PhoneNumber voicePhoneNumber;
  @override
  @FirestoreAttribute(ignore: true)
  PhoneNumber mobilePhoneNumber;

  @FirestoreAttribute(alias: 'mobilePhoneNumber')
  Map<String, String> mapMobilePhoneNumber;
  @FirestoreAttribute(alias: 'voicePhoneNumber')
  Map<String, String> mapVoicePhoneNumber;

  // Implementation specific variables
  final Firestore _db = Firestore.instance;
  final _log = Logger('MyFirebaseUser');

  static Future<MyFirebaseUser> fromFirebaseUser(
      FirebaseUser firebaseUser) async {
    final log = Logger('MyFirebaseUser');

    if (firebaseUser == null) {
      log.warning("Team is null. User was not authenticated");
      throw ArgumentError.notNull('firebaseUser');
    }

    final db = Firestore.instance;
    DocumentSnapshot snapshot;
    for (var i = 1; i <= RETRY_COUNT; i++) {
      snapshot = await db.collection('users').document(firebaseUser.uid).get();
      if (snapshot.data == null) {
        if (i == RETRY_COUNT) {
          log.warning("Retries failed. Document still null");
          return null;
        }
        log.warning(
            "Race condition where the backend hasn't created the user account yet. Trying again");
      } else
        break;
      await Future.delayed(Duration(seconds: RETRY_WAIT));
    }
    return MyFirebaseUser.fromSnapshot(snapshot).._firebaseUser = firebaseUser;
  }

  factory MyFirebaseUser.fromSnapshot(DocumentSnapshot snapshot) =>
      _$myFirebaseUserFromSnapshot(snapshot);

  @override
  MyFirebaseUser(
      {uid,
      email,
      photoUrl,
      this.firestoreDisplayName,
      @required this.teamID,
      @required this.isEditor,
      this.mapMobilePhoneNumber,
      this.mapVoicePhoneNumber}) {
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
