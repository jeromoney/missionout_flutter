import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/Provider/AuthService/auth_service.dart';

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
  Future<bool> signOut(){
    return Future.value(true);
  }

  @override
  FirebaseUser get firebaseUser => null;
}
