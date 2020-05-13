import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:missionout/Provider/AuthService/auth_service.dart';

class GoogleAuthService extends AuthService {
  // user has already signed in
  GoogleAuthService.fromUser(FirebaseUser user) {
    _firebaseUser = user;
  }

  // user has not signed in
  GoogleAuthService();

  FirebaseUser _firebaseUser;

  FirebaseAuth _auth = FirebaseAuth.instance;

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

  @override
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
    return _firebaseUser;
  }

  @override
  Future<bool> signOut() async{
    // remove token from Firestore from first, before user signs out
    var fcmToken = await _firebaseMessaging.getToken();
    _db.collection('users').document(_firebaseUser.uid).updateData({
      'tokens': FieldValue.arrayRemove([fcmToken])
    }).then((value) {
      debugPrint('Removed token to user document');
    }).catchError((error) {
      debugPrint('Error removing token from user document');
    });

    await GoogleSignIn().signOut();
    await _auth.signOut();
    return true;
  }

}
