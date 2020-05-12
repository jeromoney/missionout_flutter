import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum SignInStatus {signedOut, waiting, signedIn, error}


abstract class AuthService{
  Future<dynamic> signIn();

  @override
  @protected
  Future addTokenToFirestore(FirebaseUser user);
}