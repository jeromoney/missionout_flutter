import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:missionout/Provider/AuthService/auth_service.dart';
import 'package:missionout/Provider/User/demo_user.dart';

class DemoAuthService extends AuthService {
  @override
  String get email => "elton@email.com";

  @override
  String get displayName => "Elton";

  @override
  ImageProvider get photoImage => AssetImage("graphics/demoUser.png");

  @override
  Future<FirebaseUser> signIn() {
    return null;
  }

  @override
  @protected
  Future addTokenToFirestore(FirebaseUser user) {
    // TODO: implement addTokenToFirestore
    throw UnimplementedError();
  }

  @override
  FirebaseUser get firebaseUser => null;
}
