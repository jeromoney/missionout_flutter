import 'package:flutter/material.dart';
import 'package:missionout/app/overview_screen.dart';
import 'package:missionout/services/user/user.dart';
import 'package:missionout/app/signin_app.dart';

/// If the app is setting up the providers, a progress indicator should be displayed.
/// If the user is null, it directs to sign in page.
/// If the user is retrieved, it sets up app.
class AuthWidget extends StatelessWidget {
  final AsyncSnapshot<User> userSnapshot;

  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? OverviewScreen() : SigninApp();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
