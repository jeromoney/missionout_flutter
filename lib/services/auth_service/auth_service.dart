import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';

abstract class AuthService {
  bool get userIsLoggedIn;


  Future<User> currentUser();

  Future<User> signInWithEmailAndLink({String email, String link});

  Future<User> signInWithEmailAndPassword(String email, String password);

  Future<User> createUserWithEmailAndPassword(String email, String password);

  Future<void> sendPasswordResetEmail(String email);

  bool isSignInWithEmailLink(String link);

  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleID,
    @required String androidPackageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
    bool userMustExist = false,
  });

  Future<User> signInWithGoogle({String googleHostedDomain});

  Future<User> signInWithApple({String googleHostedDomain});

  Future<User> signInWithDemo();

  Future<void> signOut({@required BuildContext context});

  Stream<User> get onAuthStateChanged;

  Future<Team> createTeam();

  void dispose();
}
