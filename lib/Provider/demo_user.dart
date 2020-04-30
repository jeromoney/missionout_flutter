import 'package:flutter/material.dart';
import 'package:missionout/Provider/user.dart';

class DemoUser with ChangeNotifier implements User{
  @override
  String chatURI;

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
    // TODO: implement addListener
  }

  @override
  // TODO: implement chatURIisAvailable
  bool get chatURIisAvailable => null;

  @override
  String get displayName => "Elton";

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  String get email => "elton@email.com";

  @override
  // TODO: implement hasListeners
  bool get hasListeners => null;

  bool _isSignedIn = true;
  @override
  bool get isLoggedIn => _isSignedIn;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void onAuthStateChanged() {
    notifyListeners();
  }

  @override
  String get photoUrl => null;
  @override
  ImageProvider get photoImage => AssetImage("graphics/demoUser.png");


  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }

  @override
  void signIn() {
    _isSignedIn = true;
    onAuthStateChanged();
  }

  @override
  void signOut() {
    _isSignedIn = false;
    onAuthStateChanged();
  }

  @override
  // TODO: implement uid
  String get uid => null;

  @override
  Future<void> updatePhoneNumbers({String mobilePhoneNumber, String voicePhoneNumber}) {
    // TODO: implement updatePhoneNumbers
    return null;
  }


}
