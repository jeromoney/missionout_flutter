import 'package:flutter/material.dart';
import 'package:missionout/missionout_app.dart';
import 'package:provider/provider.dart';

import 'package:missionout/Provider/User/user.dart';

import 'DataLayer/app_mode.dart';

class AuthScreener extends StatelessWidget {
  AuthScreener({Key key, @required this.providers}) : super(key: key);

  var providers;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: providers,
        child: Builder(
          // ignore: missing_return
          builder: (context) {
            // Don't build material app until User object reports signed in success
            final user = Provider.of<User>(context);
            switch (user.signInStatus) {
              case SignInStatus.signedOut:
                return ResetWidget();
              case SignInStatus.waiting:
                return MaterialApp(
                    home: Scaffold(
                        body: Center(child: CircularProgressIndicator())));
              case SignInStatus.error:
                debugPrint("Auth Screener caught error");
                return ResetWidget();
              case SignInStatus.signedIn:
                // Nested Material App to show Alert Dialog when notifications is received.
                return MaterialApp(home: MissionOutApp());
              default:
                throw StateError(
                    "Unexpected Sign In State: ${user.signInStatus}");
            }
          },
        ),
      );
}

class ResetWidget extends StatefulWidget {
  // This widget adds the ability to give instructions after construction in the
  // addPostFrameCallback
  @override
  State<ResetWidget> createState() => ResetWidgetState();
}

class ResetWidgetState extends State<ResetWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appMode = Provider.of<AppMode>(context, listen: false);
      appMode.setAppMode(AppModes.signedOut,
          appMessage: "Error in sign in process");
    });
    super.initState();
  }
}
