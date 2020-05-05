import 'package:flutter/material.dart';
import 'package:missionout/Provider/user.dart';

class DemoUser with ChangeNotifier implements User{

  DemoUser(){
    notifyListeners();
  }

  @override
  bool isEditor = true;

  @override
  String mobilePhoneNumber = "+1-212-555-1234";

  @override
  String region = "US";

  @override
  String teamID;

  @override
  String voicePhoneNumber = "1-212-555-4321";

  @override
  void addListener(listener) {
    super.addListener(listener);
  }

  @override
  String get displayName => "Elton";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  String get email => "elton@email.com";

  @override
  bool get hasListeners => super.hasListeners;

  SignInStatus _signInStatus = SignInStatus.signedIn;
  @override
  SignInStatus get signInStatus => SignInStatus.signedIn;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  ImageProvider get photoImage => AssetImage("graphics/demoUser.png");


  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }

  @override
  void signIn() {
    _signInStatus = SignInStatus.signedIn;
    notifyListeners();
  }

  @override
  void signOut() {
    _signInStatus = SignInStatus.signedOut;
    notifyListeners();
  }

  @override
  // TODO: implement uid
  String get uid => null;

  @override
  Future<void> updatePhoneNumbers({String mobilePhoneNumber, String voicePhoneNumber}) {
    // TODO: implement updatePhoneNumbers
    return null;
  }

  @override
  String currentMission;


}
