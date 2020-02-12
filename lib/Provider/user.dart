import 'package:flutter/foundation.dart';

abstract class User with ChangeNotifier {
  String chatURI;
  bool isEditor;
  String teamID;

  String get displayName;

  String get photoUrl;
  String get uid;

  bool get isLoggedIn;

  bool get chatURIisAvailable;

  void signIn() {}

  void signOut() {}

  void launchChat() {}

  void onAuthStateChanged() {}
}
