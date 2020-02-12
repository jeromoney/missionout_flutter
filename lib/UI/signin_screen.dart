import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:missionout/DataLayer/user_client.dart';

class SigninScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            height: 400,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Image(image: AssetImage('graphics/missionoutlogo.png'))),
          ),
          Container(
            height: 200,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GoogleSignInButton(
                onPressed: () {
                  UserClient().signIn();
                },
                darkMode: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}