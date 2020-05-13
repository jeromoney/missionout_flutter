import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/painting/image_provider.dart';
import 'package:missionout/Provider/AuthService/auth_service.dart';
import 'package:missionout/Provider/User/user.dart';

class AppleAuthService extends AuthService {
  AppleAuthService();

  AppleAuthService.fromUser(FirebaseUser user) {
    _firebaseUser = user;
  }
  @override
  String get displayName => _appleIdCredential?.fullName?.familyName ?? "anonymous";

  @override
  String get email => _appleIdCredential?.email ?? "anonymous";

  @override
  ImageProvider get photoImage => AssetImage("graphics/apple.png");

  FirebaseUser _firebaseUser;
  @override
  FirebaseUser get firebaseUser => _firebaseUser;

  AppleIdCredential _appleIdCredential;
  final _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> signIn({List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        _appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider(providerId: 'apple.com');
        final credential = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(_appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(_appleIdCredential.authorizationCode),
        );
        final authResult = await _firebaseAuth.signInWithCredential(credential);
        _firebaseUser = authResult.user;
        if (scopes.contains(Scope.fullName)) {
          final updateUser = UserUpdateInfo();
          updateUser.displayName =
              '${_appleIdCredential.fullName.givenName} ${_appleIdCredential.fullName.familyName}';
          await _firebaseUser.updateProfile(updateUser);
        }
        return _firebaseUser;
      case AuthorizationStatus.error:
        print(result.error.toString());
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
  Future addTokenToFirestore(FirebaseUser user) {
    // TODO: implement addTokenToFirestore
    throw UnimplementedError();
  }

  @override
  void dispose() {
    super.dispose();
  }



}
