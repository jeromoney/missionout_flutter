import 'dart:collection';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/scope.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:logging/logging.dart';

import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/team/firestore_team.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/my_firebase_user.dart';
import 'package:missionout/services/user/user.dart';

const RETRY_COUNT = 5;
const RETRY_WAIT = 3;

class FirebaseAuthService extends AuthService {
  final _log = Logger('FirebaseAuthService');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final _firebaseMessaging = FirebaseMessaging();
  FirebaseUser _firebaseUser;
  String teamID;

  /// Combines data from Firebase with Firestore to return User
  Future<User> _userFromFirebase(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) return null;
    _firebaseUser = firebaseUser;
    var document;
    for (var i = 1; i < RETRY_COUNT; i++) {
      document = await _db
          .collection('users')
          .document(firebaseUser.uid)
          .get()
          .catchError((error) {
        _log.warning("Error retrieving user info from firestore", error);
        return null;
      });
      if (document.data == null)
        _log.warning(
            "Race condition where the backend hasn't created the user account yet. Trying again");
      else
        break;
      await Future.delayed(Duration(seconds: RETRY_WAIT));
    }

    final data = document.data as Map<String, dynamic>;

    if (data == null) {
      _log.warning("Retries failed. Document still null");
      return null;
    }

    var requiredKeys = ["teamID"];
    var isMissingRequiredKey =
        requiredKeys.any((requiredKey) => !data.containsKey(requiredKey));
    if (isMissingRequiredKey) {
      _log.severe("Missing required key for Team document in Firestore");
      return null;
    }
    teamID = data['teamID'];
    // If teamID is null, it means that backend set up script could not identify
    // the team automatically. e.g. User logged in from a normal gmail account.
    // Should return a null user but also automatically sign out user.
    if (teamID == null) {
      _log.warning(
          "Unable to identify the team that the user is assigned to. Logging out");
      return null;
    }

    var optionalKeys = ["isEditor", "mobilePhoneNumber", "voicePhoneNumber"];
    var isMissingOptionalKey =
        optionalKeys.any((requiredKey) => !data.containsKey(optionalKeys));
    if (isMissingOptionalKey)
      _log.warning("Missing optional key; substituting null values.");

    bool isEditor;
    data.containsKey('isEditor')
        ? isEditor = data['isEditor']
        : isEditor = false;

    PhoneNumber mobilePhoneNumber;
    PhoneNumber voicePhoneNumber;
    try {
      mobilePhoneNumber = PhoneNumber(
          isoCode: data['mobilePhoneNumber']['isoCode'],
          phoneNumber: data['mobilePhoneNumber']['phoneNumber']);
    } on TypeError catch (error) {
      _log.warning("Phone number in old format, ignoring", error);
    } on NoSuchMethodError catch (error) {
      _log.warning("Phone number in old format, ignoring", error);
    }
    try {
      voicePhoneNumber = PhoneNumber(
          isoCode: data['voicePhoneNumber']['isoCode'],
          phoneNumber: data['voicePhoneNumber']['phoneNumber']);
    } on TypeError catch (error) {
      _log.warning("Phone number in old format, ignoring", error);
    } on NoSuchMethodError catch (error) {
      _log.warning("Phone number in old format, ignoring", error);
    }

    // The user name is either served by the auth provider or can be stored in
    // the database, since some auth methods do not provide a name.
    final databaseDisplayName = data['displayName'];

    return MyFirebaseUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      photoUrl: firebaseUser.photoUrl,
      displayName: databaseDisplayName ?? firebaseUser.displayName,
      teamID: teamID,
      isEditor: isEditor,
      voicePhoneNumber: voicePhoneNumber,
      mobilePhoneNumber: mobilePhoneNumber,
    );
  }

  @override
  Future<Team> createTeam() async {
    if (teamID == null) {
      _log.warning("Team is null. User was not authenticated");
      return null;
    }
    final DocumentSnapshot snapshot =
        await _db.collection('teams').document(teamID).get();
    return FirestoreTeam.fromSnapshot(snapshot);
  }

  @override
  Future<User> currentUser() async {
    final firebaseUser = await _firebaseAuth.currentUser();
    return _userFromFirebase(firebaseUser);
  }

  @override
  void dispose() {}

  @override
  Stream<User> get onAuthStateChanged =>
      _firebaseAuth.onAuthStateChanged.asyncMap(_userFromFirebase);

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<User> signInWithEmailAndLink({String email, String link}) async {
    final AuthResult authResult =
        await _firebaseAuth.signInWithEmailAndLink(email: email, link: link);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<bool> isSignInWithEmailLink(String link) async {
    return await _firebaseAuth.isSignInWithEmailLink(link);
  }

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
  }) async {
    if (userMustExist) {
      final List<String> signInMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email: email);
      // List is empty if user not in database
      if (signInMethods.isEmpty) {
        throw StateError("User is not in database");
      }
    }

    return await _firebaseAuth.sendSignInWithEmailLink(
      email: email,
      url: url,
      handleCodeInApp: handleCodeInApp,
      iOSBundleID: iOSBundleID,
      androidPackageName: androidPackageName,
      androidInstallIfNotAvailable: androidInstallIfNotAvailable,
      androidMinimumVersion: androidMinimumVersion,
    );
  }

  @override
  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    final AuthorizationResult result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider(providerId: 'apple.com');
        final credential = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );

        final authResult = await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = authResult.user;
        if (scopes.contains(Scope.fullName)) {
          final updateUser = UserUpdateInfo();
          updateUser.displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
          await firebaseUser.updateProfile(updateUser);
        }
        return _userFromFirebase(firebaseUser);
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );
      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
    }
    return null;
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null)
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');

    final googleAuth = await googleUser.authentication;

    if (googleAuth.accessToken == null || googleAuth.idToken == null)
      throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token');
    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async {
    if (_firebaseUser == null)
      throw StateError("Signin out a user that is null");
    // remove token from Firestore from first, before user signs out
    var fcmToken = await _firebaseMessaging.getToken();
    _db.collection('users').document(_firebaseUser.uid).updateData({
      'tokens': FieldValue.arrayRemove([fcmToken])
    }).then((value) {
      _log.info('Removed token to user document');
    }).catchError((error) {
      _log.warning('Error removing token from user document', error);
    });

    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }
}
