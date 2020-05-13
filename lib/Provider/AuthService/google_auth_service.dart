import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:missionout/Provider/AuthService/auth_service.dart';
import 'package:missionout/Provider/User/my_firebase_user.dart';

class GoogleAuthService extends AuthService {
  // user has already signed in
  GoogleAuthService.fromUser(FirebaseUser user) {
    _firebaseUser = user;
  }

  // user has not signed in
  GoogleAuthService();

  FirebaseUser _firebaseUser;

  @override
  FirebaseUser get firebaseUser => _firebaseUser;

  @override
  String get displayName => _firebaseUser.displayName;

  @override
  String get email => _firebaseUser.email;

  @override
  ImageProvider get photoImage =>
      CachedNetworkImageProvider(_firebaseUser.photoUrl);

  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseMessaging = FirebaseMessaging();
  final _db = Firestore.instance;

  Future<FirebaseUser> signIn() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      // user clicked out of sign in screen
      return null;
    }

    final googleAuth = await googleUser.authentication.catchError((e) {
      debugPrint("Error with Google Auth process: $e");
      return null;
    });

    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    assert(credential != null);

    AuthResult authResult;
    try {
      authResult = await _firebaseAuth.signInWithCredential(credential);
    } on PlatformException catch (e) {
      debugPrint("Error signing user: $e");
      return null;
    }

    _firebaseUser = authResult.user;
    print("signed in " + displayName);
    addTokenToFirestore(_firebaseUser);
    return _firebaseUser;
  }

  @override
  @protected
  Future addTokenToFirestore(FirebaseUser user) async {
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
