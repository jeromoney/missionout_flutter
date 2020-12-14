import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/auth_service/firebase_auth_service.dart';
import 'package:missionout/services/auth_service/mock_auth_service.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';

enum AuthServiceType { mock, firebase }

class AuthServiceAdapter extends AuthService {
  final ValueNotifier<AuthServiceType> authServiceTypeNotifier;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final MockAuthService _mockAuthService = MockAuthService();
  final StreamController<User> _onAuthStateChangedController =
      StreamController<User>.broadcast();

  AuthServiceAdapter({@required AuthServiceType initialAuthServiceType})
      : authServiceTypeNotifier =
            ValueNotifier<AuthServiceType>(initialAuthServiceType) {
    _setup();
  }

  AuthServiceType get authServiceType => authServiceTypeNotifier.value;

  AuthService get authService => authServiceType == AuthServiceType.firebase
      ? _firebaseAuthService
      : _mockAuthService;

  StreamSubscription<User> _firebaseAuthSubscription;
  StreamSubscription<User> _mockAuthSubscription;

  void _setup() {
    _firebaseAuthSubscription =
        _firebaseAuthService.onAuthStateChanged.listen((User user) {
      if (authServiceType == AuthServiceType.firebase)
        _onAuthStateChangedController.add(user);
    }, onError: (error) {
      if (authServiceType == AuthServiceType.firebase)
        _onAuthStateChangedController.addError(error);
    });
    _mockAuthSubscription =
        _mockAuthService.onAuthStateChanged.listen((User user) {
      if (authServiceType == AuthServiceType.mock)
        _onAuthStateChangedController.add(user);
    }, onError: (error) {
      if (authServiceType == AuthServiceType.mock)
        _onAuthStateChangedController.addError(error);
    });
  }

  @override
  Future<Team> createTeam() => authService.createTeam();

  @override
  Future<User> currentUser() => authService.currentUser();

  @override
  void dispose() {
    _firebaseAuthSubscription?.cancel();
    _mockAuthSubscription?.cancel();
    _onAuthStateChangedController?.close();
    _firebaseAuthService.dispose();
    _mockAuthService.dispose();
    authServiceTypeNotifier.dispose();
  }

  @override
  Stream<User> get onAuthStateChanged => _onAuthStateChangedController.stream;

  @override
  Future<User> createUserWithEmailAndPassword(String email, String password) =>
      authService.createUserWithEmailAndPassword(email, password);

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) =>
      authService.signInWithEmailAndPassword(email, password);

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      authService.sendPasswordResetEmail(email);

  @override
  Future<User> signInWithEmailAndLink({String email, String link}) =>
      authService.signInWithEmailAndLink(email: email, link: link);

  @override
  Future<bool> isSignInWithEmailLink(String link) =>
      authService.isSignInWithEmailLink(link);

  @override
  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleID,
    @required String androidPackageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
    bool userMustExist = false,
  }) =>
      authService.sendSignInWithEmailLink(
          email: email,
          url: url,
          handleCodeInApp: handleCodeInApp,
          iOSBundleID: iOSBundleID,
          androidPackageName: androidPackageName,
          androidInstallIfNotAvailable: androidInstallIfNotAvailable,
          androidMinimumVersion: androidMinimumVersion,
          userMustExist: userMustExist);

  @override
  Future<User> signInWithApple() => authService.signInWithApple();

  @override
  Future<User> signInWithDemo() => authService.signInWithDemo();

  @override
  Future<User> signInWithGoogle() => authService.signInWithGoogle();

  @override
  Future<void> signOut() => authService.signOut();
}
