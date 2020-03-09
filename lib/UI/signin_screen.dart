import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:missionout/Provider/user.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatelessWidget {
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
                child: Image(
                    key: Key('Welcome Logo'),
                    image: AssetImage('graphics/missionoutlogo.png'))),
          ),
          Container(
            height: 200,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GoogleSignInButton(
                key: Key('Google Sign In Button'),
                onPressed: () {
                  final user = Provider.of<User>(context, listen: false);
                  user.signIn();
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
