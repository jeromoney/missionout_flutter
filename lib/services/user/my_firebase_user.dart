import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:missionout/services/user/user.dart';

class MyFirebaseUser implements User {
  @override
  final String uid;
  @override
  final String email;
  @override
  final String photoUrl;
  @override
  final String displayName;

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
  FirebaseUser _firebaseUser;

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
    addTokenToFirestore(_firebaseUser);
  }

  @override
  updatePhoneNumber(
      {@required PhoneNumber phoneNumber,
      @required PhoneNumberType type}) async {
    await _db.document('users/$uid').updateData({
      (type == PhoneNumberType.mobile
          ? 'mobilePhoneNumber'
          : 'voicePhoneNumber'): {
        'isoCode': phoneNumber.isoCode,
        'phoneNumber': phoneNumber.phoneNumber
      },
    }).catchError((error) {
      throw error;
    });
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<void> addTokenToFirestore(FirebaseUser user) async {
    // Setting up the user will be the responsibility of the server.
    // This method adds the user token to firestore
    final fcmToken = await _firebaseMessaging.getToken();
    await _db.collection('users').document(user.uid).updateData({
      'tokens': FieldValue.arrayUnion([fcmToken])
    }).then((value) {
      debugPrint('Added token to user document');
    }).catchError((error) {
      debugPrint('there was an error');
    });
  }
}

