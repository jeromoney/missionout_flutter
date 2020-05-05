// Used to switch between Demo and Normal usage. The highest widget in the tree
// Care should be called when calling notifyListeners() as new objects will
// be build down the widget tree.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AppModes{demo, firebase, signedOut}

class AppMode with ChangeNotifier{
  AppModes _appMode = AppModes.signedOut;
  FirebaseUser user;

  AppMode() {
    // On initialization, check if user is already signed in.
    _create();
  }

   _create() async {
    user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      // If user is signed in
      // tell User provider to build a MyFirebaseUser object.
       appMode = AppModes.firebase;
     }
  }

  set appMode(AppModes appMode) {
    _appMode = appMode;
    notifyListeners();
  }
  AppModes get appMode => _appMode;
}