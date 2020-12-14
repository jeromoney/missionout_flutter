import 'package:flutter/material.dart';
import 'package:missionout/app/detail_screen/detail_screen.dart';
import 'package:missionout/app/editor_screen/editor_screen.dart';
import 'package:missionout/app/overview_screen/overview_screen.dart';
import 'package:missionout/app/sign_in/LoginScreen/log_in_screen.dart';
import 'package:missionout/app/sign_in/welcome_screen.dart';
import 'package:missionout/app/user_edit_screen/user_edit_screen.dart';
import 'package:missionout/app/user_screen/user_screen.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/core/global_navigator_key.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

enum AppStatus { signedOut, signedIn }

class MissionOutApp extends StatelessWidget {
  final AppStatus appStatus;

  MissionOutApp({@required this.appStatus});

  @override
  Widget build(BuildContext context) {
    Widget initialScreen;
    final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
    Provider.of<GlobalNavigatorKey>(context, listen: false).navKey = navKey;

    switch (appStatus) {
      case AppStatus.signedOut:
        initialScreen = WelcomeScreen();
        break;

      case AppStatus.signedIn:
        if (context.watch<User>() == null)
          initialScreen = SignOutScreen();
        else
          initialScreen = OverviewScreen();
        break;
    }

    return MaterialApp(
      navigatorKey: navKey,
      title: 'Mission Out',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: initialScreen,
      routes: {
        OverviewScreen.routeName: (context) => OverviewScreen(),
        EditorScreen.routeName: (context) => EditorScreen(),
        UserScreen.routeName: (context) => UserScreen(),
        UserEditScreen.routeName: (context) => UserEditScreen(),
        DetailScreen.routeName: (context) => DetailScreen(),
        // Sign In Screens
        WelcomeScreen.routeName: (context) => WelcomeScreen(),
        LogInScreen.routeName: (context) => LogInScreen(),
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
