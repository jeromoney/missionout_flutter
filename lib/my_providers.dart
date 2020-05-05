import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/app_mode.dart';
import 'package:missionout/Provider/demo_user.dart';
import 'package:missionout/Provider/firestore_team.dart';
import 'package:missionout/Provider/team.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'Provider/demo_team.dart';
import 'Provider/user.dart';
import 'Provider/my_firebase_user.dart';

class MyProviders {
  List<SingleChildStatelessWidget> get providers {
    return [
      ChangeNotifierProvider<AppMode>(
        create: (_) => AppMode(),
      ),
      ChangeNotifierProxyProvider<AppMode, User>(
        lazy: true,
        create: (context) {
          return null;

        },
        update: (_, appMode, user) {
          debugPrint("Updating User class");
          switch (appMode.appMode) {
            case AppModes.demo:
              return DemoUser();
              break;
            case AppModes.firebase:
              if (appMode.user == null) {
                return MyFirebaseUser();
              } else {
                return MyFirebaseUser.fromUser(appMode.user);
              }
              break;
            case AppModes.signedOut:
              return null;
              break;
            default:
              return null;

              break;
          }
        },
      ),
      ProxyProvider<User, Team>(
        lazy: true,
        update: (_, user, team) {
          if (user is DemoUser) {
            return DemoTeam();
          }
          if (user is MyFirebaseUser) {
            return FirestoreTeam(user.teamID);
          }
          return null;
        },
      ),
    ];
  }
}
