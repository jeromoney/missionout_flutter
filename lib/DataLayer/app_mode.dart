// Used to switch between Demo and Normal usage. The highest widget in the tree

import 'package:flutter/material.dart';

enum AppModes{demo, normal}

class AppMode with ChangeNotifier{
  AppModes _appMode = AppModes.normal;
  set appMode(AppModes appMode) {
    _appMode = appMode;
    notifyListeners();
  }
  AppModes get appMode => _appMode;
}