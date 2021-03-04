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
                onPressed: () =>
                    Navigator.pushNamed(context, LogInScreen.routeName),
                child: Text('Log in'),
              ),
            ),
          ),
          GestureDetector(
            key: Key("privacyPolicy"),
            onTap: () => launch(Constants.privacyPolicyURL),
            child: Text(
              "Read our privacy policy",
            ),
          )
        ],
      ),
    );
  }
}
