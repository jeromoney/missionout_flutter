import 'package:flutter/foundation.dart';

abstract class User with ChangeNotifier {
  bool isEditor;
  String teamID;
  String voicePhoneNumber;
  String mobilePhoneNumber;
  String region;

  String get displayName;

  String get email;

  String get photoUrl;

  String get uid;

  bool get isLoggedIn;

  void signIn();

  void signOut();

  void onAuthStateChanged();

  Future<void> updatePhoneNumbers(
      {@required String mobilePhoneNumber,
        @required String voicePhoneNumber}) async {}
}
