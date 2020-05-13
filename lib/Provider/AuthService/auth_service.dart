import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

enum SignInStatus { signedOut, waiting, signedIn, error }

abstract class AuthService with ChangeNotifier {

  String get displayName;
  String get email;
  ImageProvider get photoImage;
  FirebaseUser get firebaseUser;

  Future<FirebaseUser> signIn();

  @override
  @protected
  Future addTokenToFirestore(FirebaseUser user);
}
