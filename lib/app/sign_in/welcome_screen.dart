import 'package:flutter/material.dart';
import 'package:missionout/app/sign_in/log_in_screen.dart';
import 'package:missionout/app/sign_in/team_domain_screen.dart';
import 'package:missionout/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeScreen extends StatelessWidget {
  static String routeName = "WelcomeScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image(
                key: Key('Welcome Logo'),
                image: AssetImage('graphics/missionoutlogo.png'),
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
          GestureDetector(
            child: Text(
              "Read our privacy policy",
            ),
            onTap: () {
              launch(Constants.privacyPolicyURL);
            },
          )
        ],
      ),
    );
  }
}
