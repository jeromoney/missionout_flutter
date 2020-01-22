import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/**
 * Once the user is logged into Firebase Auth, additional data is downloaded from the /users firestore
 */
class ExtendedUser {
  String teamID;
  bool isEditor;
  String chatURI;
  String missionID;
  String mobilePhoneNumber;
  String voicePhoneNumber;
  String region;
  DocumentReference reference;

  Future<void> setUserPermissions(FirebaseUser user) async {
    final Firestore db = Firestore.instance;

    // user specific permissions
    var document = await db.collection('users').document(user.uid).get();
    var data = document.data;
    data.containsKey('isEditor')
        ? isEditor = data['isEditor']
        : isEditor = false;
    teamID = data['teamID'];
    mobilePhoneNumber = data['mobilePhoneNumber'] ?? '';
    voicePhoneNumber = data['voicePhoneNumber'] ?? '';
    region = data['region'] ?? '';

    reference = document.reference;

    // team settings
    document = await db.collection('teams').document(teamID).get();
    data = document.data;
    data.containsKey('chatURI') ? chatURI = data['chatURI'] : chatURI = null;
  }
}
