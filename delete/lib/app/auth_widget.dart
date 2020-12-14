import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:missionout/app/mission_out_app.dart';
import 'package:missionout/services/user/user.dart';

/// If the app is setting up the providers, a progress indicator should be displayed.
/// If the user is null, it directs to sign in page.
/// If the user is retrieved, it sets up app.
///

class AuthWidget extends StatelessWidget {
  final AsyncSnapshot<User> userSnapshot;

  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppStatus appStatus;
    userSnapshot.hasData
        ? appStatus = AppStatus.signedIn
        : appStatus = AppStatus.signedOut;

    return Directionality(
        textDirection: TextDirection.ltr,
        child: MissionOutApp(
          appStatus: appStatus,
        ));
  }
}
