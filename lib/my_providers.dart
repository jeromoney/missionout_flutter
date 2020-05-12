import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/app_mode.dart';
import 'package:missionout/Provider/User/demo_user.dart';
import 'package:missionout/Provider/Team/firestore_team.dart';
import 'package:missionout/Provider/Team/team.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'Provider/Team/demo_team.dart';
import 'Provider/User/user.dart';
import 'Provider/User/my_firebase_user.dart';

class FirebaseProviders {
  FirebaseUser _user;

  FirebaseProviders(this._user);

  List<SingleChildStatelessWidget> get providers {
    return [
      ChangeNotifierProvider<User>(
        create: (_) {
          if (_user == null) {
            return MyFirebaseUser();
          } else {
            return MyFirebaseUser.fromUser(_user);
          }
        },
      ),
      ProxyProvider<User, Team>(
        lazy: true,
        update: (_, user, team) {
          // Don't return the the team until you have a teamID
          if (user.teamID == null) {
            return null;
          } else {
            return FirestoreTeam(user.teamID);
          }
        },
      ),
    ];
  }
}

class DemoProviders {
  List<SingleChildStatelessWidget> get providers {
    return [
      ChangeNotifierProvider<User>(
        create: (_) => DemoUser(),
      ),
      Provider<Team>(
        create: (_) => DemoTeam(),
      ),
    ];
  }
}
