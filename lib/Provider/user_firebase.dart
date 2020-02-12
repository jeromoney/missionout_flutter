import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:missionout/Provider/user.dart';
import 'package:url_launcher/url_launcher.dart';

class MyFirebaseUser with ChangeNotifier implements User {
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
  String chatURI;
  @override
  String teamID;

  @override
  String get displayName => _firebaseUser.displayName;

  @override
  String get email => _firebaseUser.email;

  @override
  String get uid => _firebaseUser.uid;

  @override
  String get photoUrl => _firebaseUser.photoUrl;

  @override
  bool get isLoggedIn => _firebaseUser != null;

  @override
  bool get chatURIisAvailable => chatURI != null;

  MyFirebaseUser() {
    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser) async {
      _firebaseUser = firebaseUser;
      if (_firebaseUser == null) {
        // clear out stored fields. TODO- A little clunky, should just get a new instance
        clearUserPermissions();
      } else {
        // Got a new user, so check firestore for user settings
        await setUserPermissions();
      }
      onAuthStateChanged();
    });
  }

  @override
  void signIn() async {
    //check if user is signed in
    final googleSignIn = GoogleSignIn();
    final auth = FirebaseAuth.instance;
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);

    addTokenToFirestore(user);
  }

  @override
  void signOut() async {
    final auth = FirebaseAuth.instance;
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await auth.signOut();
    _firebaseUser = null;
    onAuthStateChanged();
  }

  Future<void> addTokenToFirestore(FirebaseUser user) async {
    // Setting up the user will be the responsibility of the server.
    // This method adds the user token to firestore
    final idToken = await user.getIdToken();
    final data = {
      'token': idToken.token,
      'platform': Platform.operatingSystem,
      'createdAt': FieldValue.serverTimestamp()
    };
    await Firestore.instance
        .collection('users/${user.uid}/tokens')
        .document(idToken.token)
        .setData(data)
        .then((value) {
      debugPrint('Added token to database');
    }).catchError((error) {
      debugPrint('there was an error');
    });
  }

  @override
  void onAuthStateChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    FirebaseAuth.instance.onAuthStateChanged.drain();
  }

  @override
  void launchChat() {
    launch(chatURI);
  }

  Future<void> setUserPermissions() async {
    final Firestore db = Firestore.instance;

    // user specific permissions
    var document =
        await db.collection('users').document(_firebaseUser.uid).get();
    var data = document.data;
    data.containsKey('isEditor')
        ? isEditor = data['isEditor']
        : isEditor = false;
    teamID = data['teamID'];
    mobilePhoneNumber = data['mobilePhoneNumber'] ?? '';
    voicePhoneNumber = data['voicePhoneNumber'] ?? '';
    region = data['region'] ?? '';
    // team settings
    document = await db.collection('teams').document(teamID).get();
    data = document.data;
    data.containsKey('chatURI') ? chatURI = data['chatURI'] : chatURI = null;
  }

  clearUserPermissions() {
    voicePhoneNumber = null;
    mobilePhoneNumber = null;
    isEditor = false;
    chatURI = null;
    teamID = null;
  }
}
