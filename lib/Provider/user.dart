import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

enum SignInStatus {signedOut, waiting, signedIn}

abstract class User with ChangeNotifier {
  bool isEditor;
  String teamID;
  String voicePhoneNumber;
  String mobilePhoneNumber;
  String region;
  String currentMission;

  String get displayName;

  String get email;
  ImageProvider get photoImage;

  String get uid;

  SignInStatus get signInStatus;

  void signIn();

  void signOut();

  Future<void> updatePhoneNumbers(
      {@required String mobilePhoneNumber,
        @required String voicePhoneNumber}) async {}
}
