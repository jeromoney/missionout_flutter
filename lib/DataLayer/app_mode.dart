// Used to switch between Demo and Normal usage. The highest widget in the tree
// Care should be called when calling notifyListeners() as new objects will
// be build down the widget tree.

import 'package:flutter/material.dart';

enum AppModes{demo, normal}

class AppMode with ChangeNotifier{
  AppMode(){
    // On initialization, Check if user is already signed in.
    // If user is signed in
    // tell User provider to build a MyFirebaseUser object.
    // If not, the user object should be null
  }

  AppModes _appMode = AppModes.normal;
  set appMode(AppModes appMode) {
    _appMode = appMode;
    notifyListeners();
  }
  AppModes get appMode => _appMode;
}