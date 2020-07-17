import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

/// Builds out providers for [MaterialApp]
/// [AuthWidget] is the descendant widget to control signed in / signed out states
class AuthWidgetBuilder extends StatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;

  const AuthWidgetBuilder({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return StreamBuilder(
      stream: authService.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        final user = snapshot.data;
        if (user != null) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<User>.value(
                value: user,
              ),
              FutureProvider<Team>(
                initialData: null,
                create: (_) async => authService.createTeam(),
              ),
              Provider<DocumentReferenceHolder>(
                create: (_) => DocumentReferenceHolder(),
              ),
              ProxyProvider<DocumentReferenceHolder, DocumentReference>(
                update: (_, holder, ___) => holder.documentReference,
              )
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

class DocumentReferenceHolder {
  DocumentReference documentReference;
}
