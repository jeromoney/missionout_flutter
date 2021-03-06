import 'package:flutter/material.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

/// Builds out providers for [MaterialApp]
/// [AuthWidget] is the descendant widget to control signed in / signed out states
class AuthWidgetBuilder extends StatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;

  const AuthWidgetBuilder({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    return StreamBuilder(
      stream: authService.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        final user = snapshot.data;
        if (user != null) {
          assert(user.teamID != null);
          if (context != null) {
            user.context = context;
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<User>.value(
                value: user,
              ),
              FutureProvider<Team>(
                create: (_) async => authService.createTeam(),
                catchError: (_, __) {
                  return null;
                },
              ),
            ],
            child: builder(context, snapshot),
          );
        }
        // If not signed in, build app with no providers
        return builder(context, snapshot);
      },
    );
  }
}
