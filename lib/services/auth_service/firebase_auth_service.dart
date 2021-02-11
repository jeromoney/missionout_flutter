import 'package:apple_sign_in/apple_sign_in.dart' as apple;
import 'package:apple_sign_in/scope.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:missionout/communication_plugin/communication_plugin.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/team/firestore_team.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/my_firebase_user.dart';
import 'package:missionout/services/user/user.dart';

class FirebaseAuthService extends AuthService {
  final _log = Logger('FirebaseAuthService');
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  auth.User _firebaseUser;
  String teamID;

  @override
  bool get userIsLoggedIn => true;

  /// Combines data from Firebase with Firestore to return User
  Future<MyFirebaseUser> _userFromFirebase(auth.User firebaseUser) async {
    if (firebaseUser == null) {
      _log.warning('FirebaseUser can not be null');
      throw ArgumentError.notNull('firebaseUser');
    }
    final MyFirebaseUser myUser =
        await MyFirebaseUser.fromFirebaseUser(firebaseUser);
    teamID = myUser.teamID;
    _firebaseUser = firebaseUser;
    return myUser;
  }

  @override
  Future<Team> createTeam() async {
    assert(teamID != null);
    return FirestoreTeam.fromTeamID(teamID);
  }

  @override
  Future<User> currentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    return _userFromFirebase(firebaseUser);
  }

  @override
  void dispose() {}

  @override
  Stream<User> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().asyncMap(_userFromFirebase);

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final auth.UserCredential authResult = await _firebaseAuth
        .signInWithCredential(auth.EmailAuthProvider.credential(
      email: email,
      password: password,
    ));
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final auth.UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<User> signInWithEmailAndLink({String email, String link}) async {
    final auth.UserCredential authResult =
        await _firebaseAuth.signInWithEmailLink(email: email, emailLink: link);
    return _userFromFirebase(authResult.user);
  }

  @override
  bool isSignInWithEmailLink(String link) =>
      _firebaseAuth.isSignInWithEmailLink(link);

  @override
  Future sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleID,
    @required String androidPackageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
    bool userMustExist = false,
  }) async {
    if (userMustExist) {
      final List<String> signInMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);
      // List is empty if user not in database
      if (signInMethods.isEmpty) throw Exception("User is not in database");
    }
    return _firebaseAuth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: auth.ActionCodeSettings(
          url: url,
          handleCodeInApp: handleCodeInApp,
          iOSBundleId: iOSBundleID,
          androidPackageName: androidPackageName,
          androidInstallApp: androidInstallIfNotAvailable,
          androidMinimumVersion: androidMinimumVersion,
        ));
  }

  @override
  Future<User> signInWithApple({String googleHostedDomain}) async {
    const scopes = [Scope.fullName, Scope.email];
    final apple.AuthorizationResult result = await apple.AppleSignIn.performRequests(
        [const apple.AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case apple.AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = auth.OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
          String.fromCharCodes(appleIdCredential.authorizationCode),
        );

        final authResult = await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = authResult.user;
        final appleFullName = appleIdCredential.fullName;
        if (scopes.contains(Scope.fullName) &&
            appleFullName.givenName != null &&
            appleFullName.familyName != null) {
          final displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
          await auth.FirebaseAuth.instance.currentUser
              .updateProfile(displayName: displayName);
        }
        return _userFromFirebase(firebaseUser);
      case apple.AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );
      case apple.AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
    }
    return null;
  }

  @override
  Future<User> signInWithGoogle({String googleHostedDomain}) async {
    final googleSignIn = GoogleSignIn(hostedDomain: googleHostedDomain);
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
    final googleAuth = await googleUser.authentication;
    if (googleAuth.idToken == null) {
      throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token');
    }
    final credential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final auth.UserCredential authResult =
        await _firebaseAuth.signInWithCredential(credential);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithDemo() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future signOut() async {
    if (_firebaseUser == null) {
      throw StateError("Signing out a user that is null");
    }
    for (final plugin in communicationPlugins) {
      await plugin.signOut();
    }

    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }
}
