import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:logging/logging.dart';

import 'package:missionout/constants/constants.dart';

import 'log_in_screen_model.dart';

class LogInScreen extends StatefulWidget {
  static const routeName = '/logInScreen';
  final _log = Logger('LogInScreen');

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPasswordField = false;

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
                      onPressed: () {
                        try {
                          model.signInWithGoogle;
                        } on Exception catch (e) {
                          //assert(false);
                        }
                      },
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
                          if (_showPasswordField) ...[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                obscureText: true,
                                controller: _passwordController,
                                validator: (password) {
                                  if (password.length < 6)
                                    return 'Password too short (less than 6 characters)';
                                },
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    border: OutlineInputBorder()),
                              ),
                            )
                          ],
                          SizedBox(
                              width: Constants.column_width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text(!_showPasswordField
                                      ? 'Request email link'
                                      : 'Sign in with password'),
                                  onPressed: () async {
                                    if (!_formKey.currentState.validate())
                                      return;
                                    if (!_showPasswordField)
                                      model.sendEmailLink(
                                          email: _emailController.text);
                                    else {
                                      await model
                                          .signInWithEmailAndPassword(
                                              _emailController.text,
                                              _passwordController.text)
                                          .catchError((error) {
                                        final snackbar = SnackBar(
                                          content: Text(
                                              "Unable to login with email/password"),
                                        );
                                        Scaffold.of(context)
                                            .showSnackBar(snackbar);
                                        widget._log.warning(
                                            'Unable to login with email/password',
                                            error);
                                      });
                                    }
                                  },
                                  onLongPress: () {
                                    setState(() {
                                      _showPasswordField = !_showPasswordField;
                                    });
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
