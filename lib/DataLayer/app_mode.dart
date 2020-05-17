import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';

import 'package:missionout/Provider/AuthService/apple_auth_service.dart';
import 'package:missionout/Provider/AuthService/auth_service.dart';
import 'package:missionout/Provider/AuthService/demo_auth_service.dart';
import 'package:missionout/Provider/AuthService/google_auth_service.dart';
import 'package:missionout/my_providers.dart';

enum AppModes { demo, google, signedOut, apple }

class AppMode with ChangeNotifier {
  AppModes _appMode = AppModes.signedOut;

  FirebaseUser _user;
  List<SingleChildStatelessWidget> _providers;

  List<SingleChildStatelessWidget> get providers => _providers;

  FirebaseUser get user {
    // delete user after access. This prevents it from being accessed twice,
    // since it is only used at startup
    final tmpUser = _user;
    _user = null;
    return tmpUser;
  }

  dynamic _authService;

  String _appMessage; // One time read string to pass messages to sign in screen

  String get appMessage {
    // Mission Impossible -- delete value after reading it
    final tmp = _appMessage;
    _appMessage = null;
    return tmp;
  }

  AppMode() {
    // On initialization, check if user is already signed in.
    _create();
  }

  _create() async {
    _user = await FirebaseAuth.instance.currentUser();
    if (_user != null) {
      //  user is already signed in
      final authProvider = _user.providerData[0].providerId;
      AuthService authService;
      AppModes appMode;
      switch (authProvider) {
        case "apple.com":
          {
            authService = AppleAuthService.fromUser(user);
            appMode = AppModes.apple;
            break;
          }
        case "google.com":
          {
            authService = GoogleAuthService.fromUser(user);
            appMode = AppModes.google;
            break;
          }
        case "firebase":
          {
            authService = GoogleAuthService.fromUser(user);
            appMode = AppModes.google;
            break;
          }
        default:
          {
            throw StateError("Unexpected authorization method: $authProvider");
          }
      }
      _providers = FirebaseProviders.fromAuthService(authService).providers;
      setAppMode(appMode);
    }

    FirebaseMessaging().onTokenRefresh.listen((token) {
      debugPrint("onTokenRefresh listener fired: $token");
    });
    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser) async {
      debugPrint("onAuthStateChanged listener fired: $firebaseUser");
      if (appMode == AppModes.google && firebaseUser == null) {
        // The app thinks it is in Firebase mode, but there is no current user.
        // Probably a sign out out issue.
        debugPrint("Firebase user is null, so signing out");
        _user = null;
        setAppMode(AppModes.signedOut);
      }
    });
  }

  void setAppMode(AppModes appMode, {String appMessage}) {
    if (appMode == _appMode) {
      // nothing changed. do nothing.
      debugPrint("App tried to change modes with the same mode");
      //return;
    }
    if (appMessage != null) {
      _appMessage = appMessage;
    }
    _appMode = appMode;
    notifyListeners();
  }

  AppModes get appMode => _appMode;

  @override
  void dispose() {
    FirebaseMessaging().onTokenRefresh.drain();
    FirebaseAuth.instance.onAuthStateChanged.drain();
    super.dispose();
  }

  Future<bool> signIn(AppModes appMode) async {
    // get AuthService of the requested type
    switch (appMode) {
      case AppModes.demo:
        _authService = DemoAuthService();
        break;
      case AppModes.google:
        _authService = GoogleAuthService();
        break;
      case AppModes.signedOut:
        return true;
      case AppModes.apple:
        _authService = AppleAuthService();
        break;
    }

    // Getting a user means success
    var user = await _authService.signIn();
    if (user == null && appMode != AppModes.demo) {
      setAppMode(AppModes.signedOut, appMessage: "Error in sign in process");
      return false;
    }

    if (appMode == AppModes.demo) {
      _providers = DemoProviders().providers;
    } else if (appMode == AppModes.apple || appMode == AppModes.google) {
      _providers = FirebaseProviders.fromAuthService(_authService).providers;
    } else {
      throw StateError("Unexpected App Mode: $appMode");
    }

    setAppMode(appMode);
    return true;
  }
}
