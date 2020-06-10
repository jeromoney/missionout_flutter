import 'package:flutter/material.dart';
import 'package:missionout/app/detail_screen/detail_screen.dart';
import 'package:missionout/app/editor_screen/editor_screen.dart';
import 'package:missionout/app/overview_screen.dart';
import 'package:missionout/app/response_screen.dart';
import 'package:missionout/app/sign_in/log_in_screen.dart';
import 'package:missionout/app/sign_in/sign_up_screen.dart';
import 'package:missionout/app/sign_in/team_domain_screen.dart';
import 'package:missionout/app/sign_in/welcome_screen.dart';
import 'package:missionout/app/user_screen/user_screen.dart';
import 'package:missionout/core/global_navigator_key.dart';
import 'package:provider/provider.dart';

enum AppStatus { signedOut, signedIn, waiting }

class MissionOutApp extends StatefulWidget {
  final AppStatus appStatus;

  MissionOutApp({Key key, @required this.appStatus}) : super(key: key);

  @override
  _MissionOutAppState createState() => _MissionOutAppState();
}

class _MissionOutAppState extends State<MissionOutApp> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();
  Widget _initialScreen;

  @override
  Widget build(BuildContext context) {
    switch (widget.appStatus) {
      case AppStatus.signedOut:
        _initialScreen = WelcomeScreen();
        break;
      case AppStatus.signedIn:
        _initialScreen = OverviewScreen();
        break;
      case AppStatus.waiting:
        _initialScreen = WaitingScreen();
        break;
    }

    // created a new _navKey so need to update value of provider
    Provider.of<GlobalNavigatorKey>(context, listen: false).navKey = _navKey;

    return MaterialApp(
      navigatorKey: _navKey,
      title: 'Mission Out',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      darkTheme: ThemeData.dark(),
      home: _initialScreen,
      routes: {
        OverviewScreen.routeName: (context) => OverviewScreen(),
        EditorScreen.routeName: (context) => EditorScreen(),
        UserScreen.routeName: (context) => UserScreen(),
        DetailScreen.routeName: (context) => DetailScreen(),
        ResponseScreen.routeName: (context) => ResponseScreen(),
        // Sign In Screens
        WelcomeScreen.routeName: (context) => WelcomeScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        LogInScreen.routeName: (context) => LogInScreen(),
        TeamDomainScreen.routeName: (context) => TeamDomainScreen(),
        // Loading Screen
        WaitingScreen.routeName: (context) => WaitingScreen(),
      },
    );
  }
}

class WaitingScreen extends StatelessWidget {
  static const String routeName = "WaitingScreen";

  @override
  Widget build(BuildContext context) => Scaffold(
        body: LinearProgressIndicator(),
      );
}
