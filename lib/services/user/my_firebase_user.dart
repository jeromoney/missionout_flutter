import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:missionout/data_objects/phone_number_record.dart';
import 'package:missionout/services/communication_plugin/communication_plugin.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

const retryCount = 5;
const retryWait = 3; // seconds

class MyFirebaseUser with ChangeNotifier implements User {
  BuildContext _context;
  @override
  BuildContext get context => _context;
  @override
  set context(BuildContext context){
    _context = context;
    // Added token to object so we want to add tokens now
    if (_context != null) {
      _addTokenToFirestore();
    }
  }

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
  double get iOSCriticalAlertsVolume => _iOSCriticalAlertsVolume;

  @override
  set iOSCriticalAlertsVolume(double volume) {
    _iOSCriticalAlertsVolume = volume;
    _setIOSCriticalAlertsVolume(volume: volume);
  }

  double _iOSCriticalAlertsVolume;

  @override
  String get iOSSound => _iOSSound;

  @override
  set iOSSound(String iOSSound) {
    _iOSSound = iOSSound;
    _setIOSSound(iOSSound);
  }

  String _iOSSound;

  @override
  bool get enableIOSCriticalAlerts => _enableIOSCriticalAlerts;

  @override
  set enableIOSCriticalAlerts(bool enableIOSCriticalAlerts) {
    _enableIOSCriticalAlerts = enableIOSCriticalAlerts;
    _setEnableIOSCriticalAlerts(enableIOSCriticalAlerts);
  }

  bool _enableIOSCriticalAlerts;

  // Implementation specific variables
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _log = Logger('MyFirebaseUser');

  static Future<MyFirebaseUser> fromFirebaseUser(auth.User firebaseUser) async {
    if (firebaseUser.isAnonymous) {
      return MyFirebaseUser(
          firebaseUser: firebaseUser, teamID: "demoteam.com", isEditor: true);
    }

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
    for (var i = 1; i <= retryCount; i++) {
      snapshot = await db.collection('users').doc(firebaseUser.uid).get();
      if (snapshot.data() == null) {
        if (i == retryCount) {
          log.warning("Retries failed. Document still null");
          return null;
        }
        log.warning(
            "Race condition where the backend hasn't created the user account yet. Trying again");
      } else {
        break;
      }
      await Future.delayed(const Duration(seconds: retryWait));
    }

    final Map data = snapshot.data();
    final requiredKeys = ["teamID"];
    final isMissingRequiredKey =
        requiredKeys.any((requiredKey) => !data.containsKey(requiredKey));
    if (isMissingRequiredKey) {
      log.severe("Missing required key for Team document in Firestore");
      return null;
    }
    final snapshotTeamID = data['teamID'] as String;
    // If teamID is null, it means that backend set up script could not identify
    // the team automatically. e.g. User logged in from a normal gmail account.
    // Should return a null user but also automatically sign out user.
    if (snapshotTeamID == null) {
      log.warning(
          "Unable to identify the team that the user is assigned to. Logging out");
      throw auth.FirebaseAuthException(
          code: "5987", message: "User has not been assigned to a team yet");
    }

    final optionalKeys = [
      "isEditor",
      "enableIOSCriticalAlerts",
      "iOSCriticalAlertsVolume",
      "iOSSound"
    ];
    final isMissingOptionalKey =
        optionalKeys.any((optionalKey) => !data.containsKey(optionalKeys));
    if (isMissingOptionalKey) {
      log.warning("Missing optional key; substituting null values.");
    }

    bool isEditor;
    data.containsKey('isEditor')
        ? isEditor = data['isEditor'] as bool
        : isEditor = false;

    bool enableIOSCriticalAlerts;
    data.containsKey('enableIOSCriticalAlerts')
        ? enableIOSCriticalAlerts = data['enableIOSCriticalAlerts'] as bool
        : enableIOSCriticalAlerts = false;

    double iOSCriticalAlertsVolume;
    data.containsKey('iOSCriticalAlertsVolume')
        ? iOSCriticalAlertsVolume = data['iOSCriticalAlertsVolume'] as double
        : iOSCriticalAlertsVolume = 1.0;

    String iOSSound;
    data.containsKey('iOSSound')
        ? iOSSound = data['iOSSound'] as String
        : iOSSound = "school_fire_alarm.m4a";

    return MyFirebaseUser(
      firebaseUser: firebaseUser,
      teamID: snapshotTeamID,
      isEditor: isEditor,
      enableIOSCriticalAlerts: enableIOSCriticalAlerts,
      iOSCriticalAlertsVolume: iOSCriticalAlertsVolume,
      iOSSound: iOSSound,
    );
  }

  @override
  MyFirebaseUser(
      {@required this.firebaseUser,
      @required this.teamID,
      @required this.isEditor,
      bool enableIOSCriticalAlerts,
      double iOSCriticalAlertsVolume,
      String iOSSound})
      : _enableIOSCriticalAlerts = enableIOSCriticalAlerts,
        _iOSCriticalAlertsVolume = iOSCriticalAlertsVolume,
        _iOSSound = iOSSound,
        assert(teamID != null);

  @override
  Future updatePhoneNumber(
      {@required PhoneNumber phoneNumber, @required PhoneType type}) async {
    await _db.doc('users/$uid').update({
      type == PhoneType.mobile ? 'mobilePhoneNumber' : 'voicePhoneNumber': {
        'isoCode': phoneNumber.isoCode,
        'phoneNumber': phoneNumber.phoneNumber
      },
    });
  }

  Future _addTokenToFirestore() async {
    // Setting up the user will be the responsibility of the server.
    // This method adds the user token to firestore
    final communicationPluginHolder = context.read<CommunicationPluginHolder>();
    for (final plugin in communicationPluginHolder.plugins){
      try {
        final TokenHolder tokenHolder = await plugin.getToken();
        _log.info("My $plugin token is ${tokenHolder.token}");
        await _db.collection('users').doc(uid).update({
          tokenHolder.tokenList: FieldValue.arrayUnion([tokenHolder.token])
        }).then((value) {
          _log.info('Added $plugin token to user document');
        }).catchError((error) {
          _log.warning('Error adding $plugin token to user document', error);
        });
      } on PlatformException catch (e) {
        _log.warning("Unable to access $plugin token: $e");
      }
    }
  }

  Future _setEnableIOSCriticalAlerts(bool enable) async {
    await _db
        .collection('users')
        .doc(uid)
        .update({"enableIOSCriticalAlerts": enable}).then((value) {
      _log.info('Updated enableIOSCriticalAlerts to: $enable');
    }).catchError((error) {
      _log.warning('Error updating enableIOSCriticalAlerts', error);
    });
  }

  Future _setIOSCriticalAlertsVolume({double volume}) async {
    await _db
        .collection('users')
        .doc(uid)
        .update({"iOSCriticalAlertsVolume": volume}).then((value) {
      _log.info('Updated IOSCriticalAlertsVolume to: $volume');
    }).catchError((error) {
      _log.warning('Error updating enableIOSCriticalAlerts', error);
    });
  }

  @override
  Future updateDisplayName({@required String displayName}) async {
    await auth.FirebaseAuth.instance.currentUser
        .updateProfile(displayName: displayName);
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
    final documentReference = phoneNumberRecord.documentReference;
    assert(documentReference != null);
    await documentReference.delete();
  }

  Future _setIOSSound(String iOSSound) async {
    await _db
        .collection('users')
        .doc(uid)
        .update({"iOSSound": iOSSound}).then((value) {
      _log.info('Updated iOSSound to: $iOSSound');
    }).catchError((error) {
      _log.warning('Error updating iOSSound', error);
    });
  }

}
