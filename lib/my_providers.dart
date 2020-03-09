import 'package:missionout/Provider/firestore_team.dart';
import 'package:missionout/Provider/team.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'DataLayer/mission_address.dart';
import 'Provider/mock_user.dart';
import 'Provider/user.dart';
import 'Provider/my_firebase_user.dart';
enum AuthServiceType{firebase, mock}

class MyProviders {
  final AuthServiceType initialAuthServiceType;

  MyProviders(this.initialAuthServiceType);

  List<SingleChildStatelessWidget> get providers {
    return [
      ChangeNotifierProvider<User>(
        create: (_) => initialAuthServiceType == AuthServiceType.firebase ? MyFirebaseUser() : MockUser(),
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
