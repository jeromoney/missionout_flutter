
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/image_provider.dart';
import 'package:missionout/Provider/AuthService/auth_service.dart';

class AuthServiceFake implements AuthService{
  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  String get displayName => "Joe Smith";

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  String get email => "joe@smith.com";

  @override
  // TODO: implement firebaseUser
  FirebaseUser get firebaseUser => null;

  @override
  // TODO: implement hasListeners
  bool get hasListeners => false;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  ImageProvider get photoImage => AssetImage("graphics/apple.png");

  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }

  @override
  Future<FirebaseUser> signIn() {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<bool> signOut() => Future.value(true);
}