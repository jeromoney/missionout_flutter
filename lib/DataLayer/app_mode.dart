// Used to switch between Demo and Normal usage. The highest widget in the tree
// Care should be called when calling notifyListeners() as new objects will
// be build down the widget tree.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AppModes{demo, firebase, signedOut}

class AppMode with ChangeNotifier{
  AppModes _appMode = AppModes.signedOut;
  FirebaseUser _user;
  FirebaseUser get user {
    // delete user after access. This prevents it from being accessed twice,
    // since it is only used at startup
    final tmpUser = _user;
    _user = null;
    return tmpUser;
  }

  AppMode() {
    // On initialization, check if user is already signed in.
    _create();
  }

   _create() async {
     _user = await FirebaseAuth.instance.currentUser();
    if (_user != null) {
      // If user is signed in
      // tell User provider to build a MyFirebaseUser object.
       appMode = AppModes.firebase;
     }
     //    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser) async {
//      debugPrint("onAuthStateChanged listener fired");
//      _firebaseUser = firebaseUser;
//      if (_firebaseUser == null) {
//        // clear out stored fields. TODO- A little clunky, should just get a new instance
//        clearUserPermissions();
//      } else {
//        // Got a new user, so check firestore for user settings
//        await setUserPermissions().catchError((e){
//          // the onAuthState is being called multiple times which is causes race
//          // conditions. The user is being torn down but called a second time
//          debugPrint("Firebase user called during signout process");
//        });
//        notifyListeners();
//      }
//    });
  }

  set appMode(AppModes appMode) {
    _appMode = appMode;
    notifyListeners();
  }
  AppModes get appMode => _appMode;
}