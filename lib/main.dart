import 'package:flutter/material.dart';

import 'package:missionout/UI/signin_screen.dart';
import 'package:missionout/missionout_app.dart';
import 'package:provider/provider.dart';

import 'DataLayer/app_mode.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppMode(),
      child: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final appMode = Provider.of<AppMode>(context);
    final appModeState = appMode.appMode;
    if (appModeState == AppModes.signedOut) {
      return MaterialApp(
        home: SafeArea(child: SigninScreen()),
        darkTheme: ThemeData.dark(),
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
      );
    } else {
      // this state can only be entered once the user is signed in
      final providers = appMode.providers;
      assert(providers != null);
      return MultiProvider(
        providers: providers,
        child: MaterialApp(home: SafeArea(child: MissionOutApp())),
      );
    }
  }
}
