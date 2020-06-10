import 'package:flutter/material.dart';
import 'package:missionout/app/sign_in/log_in_screen.dart';
import 'package:missionout/app/sign_in/team_domain_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String routeName = "WelcomeScreen";

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _darkMode;

  @override
  Widget build(BuildContext context) {
    _darkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: !_darkMode ? Colors.white : Colors.grey[800],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: !_darkMode
                  ? Image(
                      key: Key('Welcome Logo'),
                      image: AssetImage('graphics/missionoutlogo.png'),
                    )
                  : ColorFiltered(
                      // Inverts black logo to white
                      colorFilter: ColorFilter.matrix([
                        //R  G   B    A  Const
                        -1, 0, 0, 0, 255, //
                        0, -1, 0, 0, 255, //
                        0, 0, -1, 0, 255, //
                        0, 0, 0, 1, 0, //
                      ]),
                      child: Image(
                        image: AssetImage('graphics/missionoutlogo.png'),
                      ),
                    ),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  RaisedButton(
                    child: Text("Sign Up"),
                    onPressed: () => Navigator.pushNamed(
                        context, TeamDomainScreen.routeName),
                  ),
                  FlatButton(
                    child: Text('Log in'),
                    onPressed: () =>
                        Navigator.pushNamed(context, LogInScreen.routeName),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
