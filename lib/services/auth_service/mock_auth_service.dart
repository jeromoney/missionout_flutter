import 'dart:async';

import 'package:flutter/material.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';

class MockAuthService extends AuthService {

  @override
  bool get userIsLoggedIn => true;
  @override
  Future<Team> createTeam() {
    // TODO: implement createTeam
    throw UnimplementedError();
  }

  @override
  Future<User> currentUser() {
    // TODO: implement currentUser
    throw UnimplementedError();
  }

  @override
  void dispose() {
    _onAuthStateChangedController?.close();
  }

  final StreamController<User> _onAuthStateChangedController =
      StreamController<User>();

  @override
  // TODO: implement onAuthStateChanged
  Stream<User> get onAuthStateChanged => _onAuthStateChangedController.stream;

  @override
  Future<User> sendSignInWithEmailLink(
      {String email,
      String url,
      bool handleCodeInApp,
      String iOSBundleID,
      String androidPackageName,
      bool androidInstallIfNotAvailable,
      String androidMinimumVersion,
      bool userMustExist = false}) {
    // TODO: implement sendSignInWithEmailLink
    throw UnimplementedError();
  }

  @override
  Future<User> signInWithApple({String googleHostedDomain}) {
    // TODO: implement signInWithApple
    throw UnimplementedError();
  }

  @override
  Future<User> signInWithEmailAndLink({
    String email,
    String link,
  }) {
    // TODO: implement signInWithEmailAndLink
    throw UnimplementedError();
  }

  @override
  Future<User> signInWithGoogle({String googleHostedDomain}) {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<void> signOut({@required BuildContext context}) {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  bool isSignInWithEmailLink(String link) {
    // TODO: implement isSignInWithEmailLink
    throw UnimplementedError();
  }

  @override
  Future<User> createUserWithEmailAndPassword(String email, String password) {
    // TODO: implement createUserWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<User> signInWithDemo() {
    // TODO: implement signInWithDemo
    throw UnimplementedError();
  }
}
