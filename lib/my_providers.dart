import 'package:missionout/Provider/firestore_team.dart';
import 'package:missionout/Provider/team.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'DataLayer/mission_address.dart';
import 'Provider/database.dart';
import 'Provider/firestore_database.dart';
import 'Provider/user.dart';
import 'Provider/user_firebase.dart';

class MyProviders {
  List<SingleChildStatelessWidget> get providers {
    return [
      ChangeNotifierProvider<User>(
        create: (_) => MyFirebaseUser(),
      ),
      ProxyProvider<User, Database>(
        create: (_) => FirestoreDatabase(),
        update: (_, user, database) {
          database.teamID = user.teamID;
          database.uid = user.uid;
          return database;
        },
        updateShouldNotify: (Database a, Database b) {
// TODO - understand what this does
          return true;
        },
      ),
      ProxyProvider<User, Team>(
        lazy: false,
        create: (_) => FirestoreTeam(),
        update: (_, user, team) {
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
