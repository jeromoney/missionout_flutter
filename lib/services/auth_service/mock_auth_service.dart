import 'dart:async';

import 'package:apple_sign_in/scope.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';

class MockAuthService extends AuthService{
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
  Future<User> sendSignInWithEmailLink({String email, String url, bool handleCodeInApp, String iOSBundleID, String androidPackageName, bool androidInstallIfNotAvailable, String androidMinimumVersion}) {
    // TODO: implement sendSignInWithEmailLink
    throw UnimplementedError();
  }

  @override
  Future<User> signInWithApple({List<Scope> scopes}) {
    // TODO: implement signInWithApple
    throw UnimplementedError();
  }

  @override
  Future<User> signInWithEmailAndLink({String email, String link,}) {
    // TODO: implement signInWithEmailAndLink
    throw UnimplementedError();
  }

  @override
  Future<User> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<bool> isSignInWithEmailLink(String link) {
    // TODO: implement isSignInWithEmailLink
    throw UnimplementedError();
  }


}