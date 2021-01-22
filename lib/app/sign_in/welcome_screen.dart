import 'package:flutter/material.dart';
import 'package:missionout/app/sign_in/LoginScreen/log_in_screen.dart';
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
              child: RaisedButton(
                child: Text('Log in'),
                onPressed: () =>
                    Navigator.pushNamed(context, LogInScreen.routeName),
              ),
            ),
          ),
          GestureDetector(
            key: Key("privacyPolicy"),
            child: Text(
              "Read our privacy policy",
            ),
            onTap: () => launch(Constants.privacyPolicyURL),
          )
        ],
      ),
    );
  }
}
