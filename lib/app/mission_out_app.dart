import 'package:flutter/material.dart';
import 'package:missionout/app/detail_screen/detail_screen.dart';
import 'package:missionout/app/editor_screen/editor_screen.dart';
import 'package:missionout/app/overview_screen/overview_screen.dart';
import 'package:missionout/app/sign_in/log_in_screen.dart';
import 'package:missionout/app/sign_in/sign_up_screen.dart';
import 'package:missionout/app/sign_in/team_domain_screen.dart';
import 'package:missionout/app/sign_in/welcome_screen.dart';
import 'package:missionout/app/user_edit_screen/user_edit_screen.dart';
import 'package:missionout/app/user_screen/user_screen.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/core/global_navigator_key.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/user/user.dart';
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
        final user = context.watch<User>();
        if (user == null)
          _initialScreen = SignOutScreen();
        else
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
      home: _initialScreen,
      routes: {
        OverviewScreen.routeName: (context) => OverviewScreen(),
        EditorScreen.routeName: (context) => EditorScreen(),
        UserScreen.routeName: (context) => UserScreen(),
        UserEditScreen.routeName: (context) => UserEditScreen(),
        DetailScreen.routeName: (context) => DetailScreen(),
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

class SignOutScreen extends StatefulWidget {
  static const String routeName = "SignOutScreen";

  @override
  _SignOutScreenState createState() => _SignOutScreenState();
}

class _SignOutScreenState extends State<SignOutScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final navKey =
          Provider.of<GlobalNavigatorKey>(context, listen: false).navKey;
      await PlatformAlertDialog(
        title: "Email address not identified",
        content:
            "Sign up with a different email address or contact your administrator for help",
        defaultActionText: Strings.ok,
      ).show(navKey.currentState.overlay.context);
      final authService = context.read<AuthService>();
      authService.signOut();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: LinearProgressIndicator(),
      );
}
