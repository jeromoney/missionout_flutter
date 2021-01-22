import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:missionout/app/mission_out_app.dart';
import 'package:missionout/services/firebase_link_handler.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

/// If the app is setting up the providers, a progress indicator should be displayed.
/// If the user is null, it directs to sign in page.
/// If the user is retrieved, it sets up app.
///

class AuthWidget extends StatefulWidget {
  final AsyncSnapshot<User> userSnapshot;
  final bool runInDemoMode;

  const AuthWidget(
      {Key key, @required this.userSnapshot, this.runInDemoMode = false})
      : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    AppStatus appStatus;
    widget.userSnapshot.hasData
        ? appStatus = AppStatus.signedIn
        : appStatus = AppStatus.signedOut;

    return Directionality(
        textDirection: TextDirection.ltr,
        child: MissionOutApp(
          appStatus: appStatus,
        ));
  }

  @override
  void initState() {
    super.initState();
    if (widget.runInDemoMode) WidgetsBinding.instance.addPostFrameCallback((_) {
      final linkHandler = context.read<FirebaseLinkHandler>();
      linkHandler.signInToDemo();
    });
  }
}
