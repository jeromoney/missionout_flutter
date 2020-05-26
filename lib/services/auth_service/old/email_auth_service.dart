import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/image_provider.dart';
import 'package:missionout/services/auth_service/auth_service.dart';

class EmailAuthService extends AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;

  String _email;

  EmailAuthService({String email}) {
    _email = email;
  }

  EmailAuthService.fromUser(FirebaseUser user){
    _firebaseUser = user;
  }

  @override
  // TODO: implement displayName
  String get displayName => throw UnimplementedError();

  @override
  String get email => _email;

  @override
  // TODO: implement firebaseUser
  FirebaseUser get firebaseUser => _firebaseUser;

  @override
  ImageProvider get photoImage => AssetImage("graphics/demoUser.png");

  @override
  Future<FirebaseUser> signIn() async {
      var i = await _auth.fetchSignInMethodsForEmail(email: "fdghsjdfhsdf@gmail.com");

    final AuthResult result = await _auth.createUserWithEmailAndPassword(email: "hello@world.com",password: "hellowporld");
    return result.user;
//    await _auth.sendSignInWithEmailLink(
//        email: _email,
//        url: "beaterboofs.com",
//        handleCodeInApp: true,
//        iOSBundleID: "com",
//        androidPackageName: "com",
//        androidInstallIfNotAvailable: true,
//        androidMinimumVersion: "18");
    //throw UnimplementedError();
  }

  @override
  Future<bool> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
