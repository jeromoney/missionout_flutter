import 'package:flutter/material.dart';
import 'package:missionout/welcome_screen.dart';

import '../login_screen.dart';


class SigninApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        darkTheme: ThemeData.dark(),
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => WelcomeScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
        },
      );
}




