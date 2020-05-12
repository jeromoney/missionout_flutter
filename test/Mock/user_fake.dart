
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/painting/image_provider.dart';
import 'package:missionout/Provider/User/user.dart';

class UserFake with ChangeNotifier implements User {
  bool signedIn;

  UserFake({
    this.chatURI,
    this.isEditor = true,
    this.mobilePhoneNumber = '+3455',
    this.voicePhoneNumber = '+344',
    this.signedIn = true,
  });

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
  String get photoUrl =>
      'https://images2.minutemediacdn.com/image/upload/c_fit,f_auto,fl_lossy,q_auto,w_728/v1555919852/shape/mentalfloss/magic-eye.jpg';

  @override
  String get uid => '123456';

  @override
  bool get isLoggedIn => signedIn;

  @override
  bool get chatURIisAvailable => true;

  @override
  Future<bool> signIn() async {
    signedIn = true;
    notifyListeners();
    return true;
  }

  @override
  void signOut() {
    signedIn = false;
    notifyListeners();
  }

  void launchChat() {
    if (chatURI == 'this will cause an error') {
      throw DiagnosticLevel.error;
    }
  }

  @override
  void onAuthStateChanged() {
    notifyListeners();
  }
  @override
  String region;

  @override
  // ignore: missing_return
  Future<Function> updatePhoneNumbers(
      {@required String mobilePhoneNumber,
      @required String voicePhoneNumber}) {}

  @override
  ImageProvider get photoImage => AssetImage("graphics/demoUser.png");

  @override
  String currentMission;

  @override
  SignInStatus get signInStatus {
    if (signedIn){
      return SignInStatus.signedIn;
    }
    else {
      return SignInStatus.signedOut;
    }
  }
}
