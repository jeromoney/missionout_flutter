import 'package:flutter/foundation.dart';
import 'package:missionout/Provider/user.dart';

class UserFake with ChangeNotifier implements User {
  bool signedIn = true;

  UserFake({this.chatURI, this.isEditor = true, this.mobilePhoneNumber = '+3455', this.voicePhoneNumber = '+344'});

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
  String get photoUrl => 'https://images2.minutemediacdn.com/image/upload/c_fit,f_auto,fl_lossy,q_auto,w_728/v1555919852/shape/mentalfloss/magic-eye.jpg';

  @override
  String get uid => '123456';

  @override
  bool get isLoggedIn => true;

  @override
  bool get chatURIisAvailable => true;

  @override
  void signIn() {}

  @override
  void signOut() {
    signedIn = false;
  }

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

  @override
  Future<Function> updatePhoneNumbers(
      {@required String mobilePhoneNumber, @required String voicePhoneNumber}) {

  }
}
