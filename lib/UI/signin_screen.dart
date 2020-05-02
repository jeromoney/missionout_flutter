import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:missionout/DataLayer/app_mode.dart';
import 'package:missionout/Provider/demo_user.dart';
import 'package:missionout/Provider/user.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final appMode = Provider.of<AppMode>(context, listen: false);
          appMode.appMode = AppModes.demo;
        }, child: Text("DEMO"),),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Image(
                    key: Key('Welcome Logo'),
                    image: AssetImage('graphics/missionoutlogo.png'))),
          ),
          Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GoogleSignInButton(
                key: Key('Google Sign In Button'),
                onPressed: () async {
                  final user = Provider.of<User>(context, listen: false);
                  try {
                    await user.signIn();
                  }
                  on PlatformException catch (e) {
                    final snackBar = SnackBar(content: Text(
                        'Error with Google SignIn. Try adding an account to Gmail'));
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                  }
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