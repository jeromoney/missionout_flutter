import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:missionout/Provider/AuthService/auth_service.dart';

class DemoAuthService extends AuthService{
  @override
  Future signIn() {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  @protected
  Future addTokenToFirestore(FirebaseUser user) {
    // TODO: implement addTokenToFirestore
    throw UnimplementedError();
  }

}