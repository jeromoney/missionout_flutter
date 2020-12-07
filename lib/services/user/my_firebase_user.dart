import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:logging/logging.dart';
import 'package:missionout/data_objects/phone_number_record.dart';
import 'package:missionout/services/user/user.dart';

const RETRY_COUNT = 5;
const RETRY_WAIT = 3; // seconds

class MyFirebaseUser with ChangeNotifier implements User {
  // Values from FirebaseUser
  auth.User firebaseUser;

  @override
  String get uid => !firebaseUser.isAnonymous ? firebaseUser.uid : 'anonymous';

  @override
  String get email => firebaseUser.email;

  @override
  String get photoUrl => firebaseUser.photoURL;

  @override
  String get displayName =>
      !firebaseUser.isAnonymous ? firebaseUser.displayName : 'anonymous';

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
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _log = Logger('MyFirebaseUser');

  static Future<MyFirebaseUser> fromFirebaseUser(
      auth.User firebaseUser) async {
    if (firebaseUser.isAnonymous) // TODO -- REMOVE AFTER APP STORE APPROVAL
      return MyFirebaseUser(
          firebaseUser: firebaseUser, teamID: "demoteam.com", isEditor: true);

    final log = Logger('MyFirebaseUser');
    if (firebaseUser == null) {
      log.warning("Team is null. User was not authenticated");
      throw ArgumentError.notNull('firebaseUser');
    }

    final db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot;
    // When the user first logs in, the backend creates a record in Firestore.
    // However, this async task might be front-run by the app and hence the need
    // for retries
    for (var i = 1; i <= RETRY_COUNT; i++) {
      snapshot = await db.collection('users').doc(firebaseUser.uid).get();
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

    final Map data = snapshot.data();
    final requiredKeys = ["teamID"];
    final isMissingRequiredKey =
        requiredKeys.any((requiredKey) => !data.containsKey(requiredKey));
    if (isMissingRequiredKey) {
      log.severe("Missing required key for Team document in Firestore");
      return null;
    }
    final String snapshotTeamID = data['teamID'];
    // If teamID is null, it means that backend set up script could not identify
    // the team automatically. e.g. User logged in from a normal gmail account.
    // Should return a null user but also automatically sign out user.
    if (snapshotTeamID == null) {
      log.warning(
          "Unable to identify the team that the user is assigned to. Logging out");
      throw auth.FirebaseAuthException(message: "User has not been assigned to a team yet");
    }

    final optionalKeys = ["isEditor"];
    final isMissingOptionalKey =
        optionalKeys.any((requiredKey) => !data.containsKey(optionalKeys));
    if (isMissingOptionalKey)
      log.warning("Missing optional key; substituting null values.");

    bool isEditor;
    data.containsKey('isEditor')
        ? isEditor = data['isEditor']
        : isEditor = false;

    return MyFirebaseUser(
      firebaseUser: firebaseUser,
      teamID: snapshotTeamID,
      isEditor: isEditor,
    );
  }

  @override
  MyFirebaseUser(
      {@required this.firebaseUser,
      @required this.teamID,
      @required this.isEditor,
      this.mobilePhoneNumber,
      this.voicePhoneNumber})
      : assert(teamID != null) {
    _addTokenToFirestore();
  }

  @override
  Future updatePhoneNumber(
      {@required PhoneNumber phoneNumber,
      @required PhoneType type}) async {
    type == PhoneType.mobile
        ? mobilePhoneNumber = phoneNumber
        : voicePhoneNumber = phoneNumber;
    await _db.doc('users/$uid').update({
      (type == PhoneType.mobile
          ? 'mobilePhoneNumber'
          : 'voicePhoneNumber'): {
        'isoCode': phoneNumber.isoCode,
        'phoneNumber': phoneNumber.phoneNumber
      },
    });
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future _addTokenToFirestore() async {
    // Setting up the user will be the responsibility of the server.
    // This method adds the user token to firestore
    final fcmToken = await _firebaseMessaging.getToken();
    await _db.collection('users').doc(this.uid).update({
      'tokens': FieldValue.arrayUnion([fcmToken])
    }).then((value) {
      _log.info('Added token to user document: $fcmToken', fcmToken);
    }).catchError((error) {
      _log.warning('Error adding token to user document', error);
    });
  }

  @override
  Future updateDisplayName({@required String displayName}) async {
    await auth.FirebaseAuth.instance.currentUser.updateProfile(displayName: displayName);
    firebaseUser = auth.FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  @override
  Stream<List<PhoneNumberRecord>> fetchPhoneNumbers() {
    final ref = _db
        .collection('teams/$teamID/phoneNumbers')
        .where("uid", isEqualTo: uid);
    return ref.snapshots().map((snapShots) => snapShots.docs
        .map((data) => PhoneNumberRecord.fromSnapshot(data))
        .where((phoneNumberRecord) => phoneNumberRecord != null)
        .toList());
  }

  @override
  Future addPhoneNumber(PhoneNumberRecord phoneNumberRecord) async {
    assert(phoneNumberRecord.uid == uid);
    await _db
        .collection('teams/$teamID/phoneNumbers')
        .doc()
        .set(phoneNumberRecord.toMap());
  }

  @override
  Future deletePhoneNumber(PhoneNumberRecord phoneNumberRecord) async {
    final documentReference = phoneNumberRecord.selfRef;
    assert(documentReference != null);
    await documentReference.delete();
  }
}
