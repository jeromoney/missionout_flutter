import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:missionout/Provider/AuthService/auth_service.dart';

class GoogleAuthService extends AuthService{
  final _firebaseAuth = FirebaseAuth.instance;
  SignInStatus _signInStatus = SignInStatus.waiting;

  Future<FirebaseUser> signIn() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      // user clicked out of sign in screen
      _signInStatus = SignInStatus.error;
      return null;
    }

    final googleAuth = await googleUser.authentication.catchError((e) {
      debugPrint("Error with Google Auth process: $e");
      _signInStatus = SignInStatus.error;
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
      _signInStatus = SignInStatus.error;
      return null;
    }

    final FirebaseUser user = authResult.user;
    print("signed in " + user.displayName);
    addTokenToFirestore(user);
    _signInStatus = SignInStatus.signedIn;
    return user;
  }

  @override
  @protected
  Future addTokenToFirestore(FirebaseUser user) {
    // TODO: implement addTokenToFirestore
    throw UnimplementedError();
  }

}