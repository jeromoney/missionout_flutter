import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:missionout/DataLayer/app_mode.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  @override
  State<SigninScreen> createState() => SigninScreenState();
}

class SigninScreenState extends State<SigninScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final appMode = Provider.of<AppMode>(context, listen: false);
            appMode.setAppMode(AppModes.demo);
          },
          child: Text("DEMO"),
        ),
        key: _scaffoldKey,
        backgroundColor: Colors.grey,
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
                    final appMode =
                        Provider.of<AppMode>(context, listen: false);
                    appMode.setAppMode(AppModes.firebase);
                  },
                  darkMode: true,
                ),
              ),
            ),
          ],
        ),
      );

  @override
  void initState() {
    super.initState();
    // Check if AppMode has any messages to display at the sign in screen
    final appMode = Provider.of<AppMode>(context, listen: false);
    final message = appMode.appMessage;
    if (message == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackbar = SnackBar(
        content: Text(message),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    });
  }
}
