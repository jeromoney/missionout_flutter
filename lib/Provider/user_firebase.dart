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
  String chatURI;

  @override
  String get displayName => _firebaseUser.displayName;

  @override
  String get photoUrl => _firebaseUser.photoUrl;



  MyFirebaseUser() {
    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser) {
      _firebaseUser = firebaseUser;
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




}
