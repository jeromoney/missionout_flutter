import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:missionout/UI/signin_screen.dart';
import 'package:missionout/auth_screener.dart';
import 'package:missionout/my_providers.dart';
import 'package:provider/provider.dart';

import 'DataLayer/app_mode.dart';

void main() => runApp(Main());

class Main extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_)=> AppMode(),child: MainScreen(),);
  }

}

class MainScreen extends StatefulWidget {
  @override
  createState() =>  _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final appMode = Provider.of<AppMode>(context);
    switch (appMode.appMode) {
      case AppModes.signedOut:
        return MaterialApp(home: SigninScreen());

      case AppModes.demo:
        final providers = DemoProviders().providers;
        return AuthScreener(providers: providers,);

      case AppModes.firebase:
        final FirebaseUser user = appMode.user;
        final firebaseProviders = FirebaseProviders(user);
        return AuthScreener(providers: firebaseProviders.providers,);

      default:
        throw ErrorDescription("Entered unexpected signin state");
    }
  }
}
