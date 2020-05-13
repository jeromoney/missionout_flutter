
import 'package:firebase_auth/firebase_auth.dart';
import 'package:missionout/Provider/AuthService/apple_auth_service.dart';
import 'package:missionout/Provider/AuthService/demo_auth_service.dart';
import 'package:missionout/Provider/AuthService/google_auth_service.dart';
import 'package:missionout/Provider/User/demo_user.dart';
import 'package:missionout/Provider/Team/firestore_team.dart';
import 'package:missionout/Provider/Team/team.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'Provider/AuthService/auth_service.dart';
import 'Provider/Team/demo_team.dart';
import 'Provider/User/user.dart';
import 'Provider/User/my_firebase_user.dart';

class FirebaseProviders {
  // Combines both Apple and Google providers
  AuthService _authService;
  FirebaseProviders.fromAuthService(AuthService authService){
    _authService = authService;
  }

  List<SingleChildStatelessWidget> get providers {
    return [
      ChangeNotifierProvider<AuthService>(
        create: (_) => _authService,
      ),
      ChangeNotifierProxyProvider<AuthService, User>(
        create: (_) => null,
        update: (_, authService, user) {
          final user = authService.firebaseUser;
          if (user == null) {
            return null;
          } else {
            return MyFirebaseUser.fromUser(user);
          }
        },
      ),
      ProxyProvider<User, Team>(
        lazy: true,
        update: (_, user, team) {
          // Don't return the the team until you have a teamID
          final teamID = user.teamID;
          if (teamID == null) {
            return null;
          } else {
            return FirestoreTeam(teamID);
          }
        },
      ),
    ];
  }
}

class DemoProviders {
  List<SingleChildStatelessWidget> get providers {
    return [
      ChangeNotifierProvider<AuthService>(
        create: (_) => DemoAuthService(),
      ),
      ChangeNotifierProvider<User>(
        create: (_) => DemoUser(),
      ),
      Provider<Team>(
        create: (_) => DemoTeam(),
      ),
    ];
  }
}