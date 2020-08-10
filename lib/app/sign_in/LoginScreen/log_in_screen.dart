import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:missionout/constants/constants.dart';

import 'log_in_screen_model.dart';

class LogInScreen extends StatefulWidget {
  static const routeName = '/logInScreen';

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = "";
    _setEmailField(context);
  }

  // TODO - refactor this with futurebuilder,
  void _setEmailField(BuildContext context) async {
    _emailController.text = await LoginScreenModel.getEmail(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final model = LoginScreenModel(context);
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) Navigator.of(context).pop();
      },
      child: Scaffold(
        body: Center(
          child: LayoutBuilder(
            builder: (context, viewportConstraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: Constants.column_width,
                    minHeight: viewportConstraints.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GoogleSignInButton(
                      text: 'Log in with Google',
                      onPressed: model.signInWithGoogle,
                    ),
                    if (model.isAppleSignInAvailable) ...[
                      AppleSignInButton(
                        text: 'Log in with Apple',
                        style: AppleButtonStyle.white,
                        onPressed: model.signInWithApple,
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
                              controller: _emailController,
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
                          SizedBox(
                              width: Constants.column_width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text('Request email link'),
                                  onPressed: () async {
                                    if (!_formKey.currentState.validate())
                                      return;
                                    model.sendEmailLink(
                                        email: _emailController.text);
                                  },
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
