import 'package:flutter/foundation.dart';

abstract class User {
  String chatURI;
  String get displayName;


  void signIn() {}

  void signOut() {}

  void launchChat() {}

  void onAuthStateChanged() {
  }
}
