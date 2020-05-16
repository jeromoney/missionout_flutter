import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:missionout/Provider/User/user.dart';

class MyFirebaseUser with ChangeNotifier implements User {
  final Firestore _db = Firestore.instance;
  FirebaseUser _firebaseUser;
  @override
  PhoneNumber voicePhoneNumber;
  @override
  PhoneNumber mobilePhoneNumber;
  @override
  String region;
  @override
  bool isEditor = false;

  @override
  String teamID;

  @override
  String get uid => _firebaseUser?.uid;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  MyFirebaseUser.fromUser(FirebaseUser user) {
    debugPrint("Creating user from already signed in account");
    _firebaseUser = user;
    setUserPermissions();
    addTokenToFirestore(_firebaseUser);
    notifyListeners();
  }

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

  Future<void> setUserPermissions() async {
    // user specific permissions
    var document =
        await _db.collection('users').document(_firebaseUser.uid).get();
    var data = document.data;
    data.containsKey('isEditor')
        ? isEditor = data['isEditor']
        : isEditor = false;
    teamID = data['teamID'];
    try {
      mobilePhoneNumber = PhoneNumber(
          isoCode: data['mobilePhoneNumber']['isoCode'],
          phoneNumber: data['mobilePhoneNumber']['phoneNumber']);
    } on TypeError  catch (e) {
      debugPrint("Phone number in old format, ignoring");
    }
    on NoSuchMethodError catch (e){
      debugPrint("Phone number in old format, ignoring");
    }
    try {
      voicePhoneNumber = PhoneNumber(
          isoCode: data['voicePhoneNumber']['isoCode'],
          phoneNumber: data['voicePhoneNumber']['phoneNumber']);
    } on TypeError  catch (e) {
      debugPrint("Phone number in old format, ignoring");
    }
    on NoSuchMethodError catch (e){
      debugPrint("Phone number in old format, ignoring");
    }
    region = data['region'] ?? '';
    subscribeToTeamPages();
    // team settings
    document = await _db.collection('teams').document(teamID).get();
    data = document.data;
    notifyListeners();
  }

  @override
  updatePhoneNumbers({
    @required PhoneNumber mobilePhoneNumberVal,
    @required PhoneNumber voicePhoneNumberVal,
  }) async {
    await _db.document('users/$uid').updateData({
      'mobilePhoneNumber': {
        'isoCode': mobilePhoneNumberVal.isoCode,
        'phoneNumber': mobilePhoneNumberVal.phoneNumber
      },
      'voicePhoneNumber': {
        'isoCode': voicePhoneNumberVal.isoCode,
        'phoneNumber': voicePhoneNumberVal.phoneNumber
      },
    }).then((value) {
      return true;
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> subscribeToTeamPages() async {
    FirebaseMessaging().subscribeToTopic(teamID).then((value) {
      debugPrint('Successfully subscribed to notifications');
    }).catchError((e) {
      debugPrint('Error subscribing to notifications');
    });
  }

  @override
  String currentMission;
}
