import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:missionout/Provider/User/user.dart';

class MyFirebaseUser with ChangeNotifier implements User {
  final Firestore _db = Firestore.instance;
  FirebaseUser _firebaseUser;
  @override
  String voicePhoneNumber;
  @override
  String mobilePhoneNumber;
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
    mobilePhoneNumber = data['mobilePhoneNumber'] ?? '';
    voicePhoneNumber = data['voicePhoneNumber'] ?? '';
    region = data['region'] ?? '';
    subscribeToTeamPages();
    // team settings
    document = await _db.collection('teams').document(teamID).get();
    data = document.data;
    notifyListeners();
  }

  clearUserPermissions() {
    voicePhoneNumber = null;
    mobilePhoneNumber = null;
    isEditor = false;
    teamID = null;
  }

  @override
  Future<void> updatePhoneNumbers({
    @required String mobilePhoneNumber,
    @required String voicePhoneNumber,
  }) async {
    await _db.document('users/$uid').updateData({
      'mobilePhoneNumber': mobilePhoneNumber,
      'voicePhoneNumber': voicePhoneNumber
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
