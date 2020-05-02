import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:missionout/Provider/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  String chatURI;
  @override
  String teamID;

  @override
  String get displayName => _firebaseUser.displayName;

  @override
  String get email => _firebaseUser.email;

  @override
  String get uid => _firebaseUser?.uid;

  @override
  ImageProvider get photoImage =>
      CachedNetworkImageProvider(_firebaseUser.photoUrl);

  bool _signInWaiting = false;

  @override
  SignInStatus get signInStatus {
    if (_signInWaiting) {
      return SignInStatus.waiting;
    } else if (_firebaseUser != null) {
      return SignInStatus.signedIn;
    } else {
      return SignInStatus.signedOut;
    }
  }

  @override
  bool get chatURIisAvailable => chatURI != null;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

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
      //onAuthStateChanged();
    });
  }

  @override
  Future<void> signIn() async {
    //check if user is signed in
    _signInWaiting = true;
    notifyListeners();
    final googleSignIn = GoogleSignIn();
    final auth = FirebaseAuth.instance;
    final googleUser = await googleSignIn.signIn().catchError((e) {
      _signInWaiting = false;
      //notifyListeners();
      throw e;
    });
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    assert(credential != null);
    final authResult = await auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    print("signed in " + user.displayName);
    _signInWaiting = false;
    addTokenToFirestore(user);
    notifyListeners();
  }

  @override
  void signOut() async {
    // remove token from Firestore from first, before user signs out
    var fcmToken = await _firebaseMessaging.getToken();
    await _db.collection('users').document(_firebaseUser.uid).updateData({
      'tokens': FieldValue.arrayRemove([fcmToken])
    }).then((value) {
      debugPrint('Removed token to user document');
    }).catchError((error) {
      debugPrint('Error removing token from user document');
    });

    final auth = FirebaseAuth.instance;
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await auth.signOut();
    _firebaseUser = null;
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

  @override
  void onAuthStateChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    FirebaseAuth.instance.onAuthStateChanged.drain();
    super.dispose();
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
    data.containsKey('chatURI') ? chatURI = data['chatURI'] : chatURI = null;
  }

  clearUserPermissions() {
    voicePhoneNumber = null;
    mobilePhoneNumber = null;
    isEditor = false;
    chatURI = null;
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
}
