
import 'package:missionout/DataLayer/app_mode.dart';
import 'package:missionout/Provider/demo_user.dart';
import 'package:missionout/Provider/firestore_team.dart';
import 'package:missionout/Provider/team.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'DataLayer/mission_address.dart';
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
        lazy: false,
        create: (_) => MyFirebaseUser(),
        update: (_, appMode, user) {
          if (appMode.appMode == AppModes.demo) {
            return DemoUser();
          } else {
            return MyFirebaseUser();
          }
        },
      ),
      ProxyProvider<User, Team>(
        lazy: false,
        create: (user) {
          if (user is DemoUser) {
            return DemoTeam();
          } else {
            return FirestoreTeam();
          }
        },
        update: (_, user, team) {
          if (user is DemoUser) {
            return team;
          }

          team.updateTeamID(user.teamID);
          return team;
        },
        updateShouldNotify: (Team a, Team b) {
          return true;
        },
      ),
      Provider<MissionAddress>(
        create: (_) => MissionAddress(),
      )
    ];
  }
}
