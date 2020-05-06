import 'package:firebase_auth/firebase_auth.dart';
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
        update: (_, user, team) => FirestoreTeam(user.teamID),
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
