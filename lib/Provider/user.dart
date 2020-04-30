import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

abstract class User with ChangeNotifier {
  bool isEditor;
  String teamID;
  String voicePhoneNumber;
  String mobilePhoneNumber;
  String region;
  String chatURI;
  bool get chatURIisAvailable;

  String get displayName;

  String get email;

  String get photoUrl;
  ImageProvider get photoImage;

  String get uid;

  bool get isLoggedIn;

  void signIn();

  void signOut();

  void onAuthStateChanged();

  Future<void> updatePhoneNumbers(
      {@required String mobilePhoneNumber,
        @required String voicePhoneNumber}) async {}
}
