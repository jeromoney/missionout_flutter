import 'package:apple_sign_in/apple_sign_in.dart' as apple;
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart'
    as flutter_buttons;
import 'package:missionout/DataLayer/app_mode.dart';
import 'package:missionout/Provider/AuthService/apple_auth_service.dart';
import 'package:missionout/Provider/AuthService/demo_auth_service.dart';
import 'package:missionout/Provider/AuthService/google_auth_service.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  @override
  State<SigninScreen> createState() => SigninScreenState();
}

class SigninScreenState extends State<SigninScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _appleSignInAvailable = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _signIn(AppModes.demo);
          },
          child: Text("DEMO"),
        ),
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
                child: Column(
                  children: [
                    flutter_buttons.GoogleSignInButton(
                      key: Key('Google Sign In Button'),
                      onPressed: () {
                        _signIn(AppModes.google);
                      },
                      darkMode: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark,
                    ),
                    if (_appleSignInAvailable)
                      Container(
                        child: flutter_buttons.AppleSignInButton(
                          style: MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                              ? flutter_buttons.AppleButtonStyle.black
                              : flutter_buttons.AppleButtonStyle.white,
                          onPressed: () {
                            _signIn(AppModes.apple);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Future<void> appleSignInAvailable() async {
    bool appleSignInAvailable = await apple.AppleSignIn.isAvailable();
    setState(() {
      _appleSignInAvailable = appleSignInAvailable;
    });
  }

  @override
  void initState() {
    super.initState();
    // check if Apple Sign In is available (i.e. only for iOS 13)
    appleSignInAvailable();

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

  _signIn(AppModes appMode) async {
    final appModeProvider = Provider.of<AppMode>(context, listen: false);
    bool success = await appModeProvider.signIn(appMode);

    // Sign in process did not complete
    if (!success) {
      final snackbar = SnackBar(
        content: Text("Error in sign in process"),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }
}
