import 'package:flutter/foundation.dart';
import 'package:missionout/Provider/user.dart';

class UserFake with ChangeNotifier implements User {
  UserFake({this.chatURI, this.isEditor = true, this.mobilePhoneNumber, this.voicePhoneNumber});

  @override
  String chatURI;
  @override
  bool isEditor;
  @override
  String teamID;
  @override
  String voicePhoneNumber;
  @override
  String mobilePhoneNumber;

  @override
  String get displayName => 'John Doe';

  @override
  String get email => 'john@doe.com';

  @override
  String get photoUrl => 'https://www.something.com/pic.jpg';

  @override
  String get uid => '123456';

  @override
  bool get isLoggedIn => true;

  @override
  bool get chatURIisAvailable => true;

  @override
  void signIn() {}

  @override
  void signOut() {}

  @override
  void launchChat() {
    if (chatURI == 'this will cause an error') {
      throw DiagnosticLevel.error;
    }
  }

  @override
  void onAuthStateChanged() {}
  @override
  String region;
}
