import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:missionout/services/apple_sign_in_available.dart';
import 'package:provider/provider.dart';

const COLUMN_WIDTH = 308.0;

class LogInScreen extends StatefulWidget {
  static const routeName = '/logInScreen';

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bool darkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, viewportConstraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: COLUMN_WIDTH, minHeight: viewportConstraints.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GoogleSignInButton(
                    text: 'Log in with Google',
                    darkMode: darkMode,
                  ),
                  if (appleSignInAvailable.isAvailable) ...[
                    AppleSignInButton(
                      text: 'Log in with Apple',
                      style: darkMode
                          ? AppleButtonStyle.black
                          : AppleButtonStyle.white,
                    )
                  ],
                  Divider(),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (email) {
                              if (!EmailValidator.validate(email))
                                return 'Enter a valid email';
                            },
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (password){
                              if (password.length < 6) return 'Password too short (less than 6 characters)';
                            },
                            decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        SizedBox(
                            width: COLUMN_WIDTH,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                child: Text('Submit'),
                                onPressed: () {
                                  _formKey.currentState.validate();
                                },
                              ),
                            )),
                        SizedBox(
                          width: COLUMN_WIDTH,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              child: Text(
                                'no password?',
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              onTap: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
