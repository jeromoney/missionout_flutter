// Used to switch between Demo and Normal usage. The highest widget in the tree
// Care should be called when calling notifyListeners() as new objects will
// be build down the widget tree.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


enum AppModes { demo, firebase, signedOut }

class AppMode with ChangeNotifier {
  AppModes _appMode = AppModes.signedOut;

  FirebaseUser _user;

  FirebaseUser get user {
    // delete user after access. This prevents it from being accessed twice,
    // since it is only used at startup
    final tmpUser = _user;
    _user = null;
    return tmpUser;
  }

  String _appMessage; // One time read string to pass messages to sign in screen

  String get appMessage {
    // Mission Impossible -- delete value after reading it
    final tmp = _appMessage;
    _appMessage = null;
    return tmp;
  }

  void setAppMode(AppModes appMode, {String appMessage}) {
    if (appMode == _appMode) {
      // nothing changed. do nothing.
      debugPrint("App tried to change modes with the same mode");
      return;
    }
    if (appMessage != null) {
      _appMessage = appMessage;
    }
    _appMode = appMode;
    notifyListeners();
  }

  AppModes get appMode => _appMode;

  AppMode() {
    // On initialization, check if user is already signed in.
    _create();
  }

  _create() async {
    _user = await FirebaseAuth.instance.currentUser();
    if (_user != null) {
      // If user is signed in
      // tell User provider to build a MyFirebaseUser object.
      setAppMode(AppModes.firebase);
    }

    FirebaseMessaging().onTokenRefresh.listen((token) {
      debugPrint("onTokenRefresh listener fired: $token");
    });
    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser) async {
      debugPrint("onAuthStateChanged listener fired: $firebaseUser");
      if (appMode == AppModes.firebase && firebaseUser == null){
        // The app thinks it is in Firebase mode, but there is no current user.
        // Probably a sign out out issue.
        debugPrint("Firebase user is null, so signing out");
        _user = null;
        setAppMode(AppModes.signedOut);
      }
    });
  }

  @override
  void dispose() {
    FirebaseMessaging().onTokenRefresh.drain();
    FirebaseAuth.instance.onAuthStateChanged.drain();
    super.dispose();
  }
}
