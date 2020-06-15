import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:logging/logging.dart';
import 'package:missionout/app/sign_in/log_in_screen_model.dart';
import 'package:missionout/app/sign_in/sign_in_manager.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:missionout/common_widgets/platform_exception_alert_dialog.dart';
import 'package:missionout/constants/constants.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/services/apple_sign_in_available.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/firebase_link_handler.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';


class LogInScreen extends StatefulWidget {
  static const routeName = '/logInScreen';
  final _log = Logger('LogInScreen');
  FirebaseLinkHandler _linkHandler;

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  EmailPasswordSignInModel _model;

  @override
  Widget build(BuildContext context) {
    final bool darkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);
    final signInManager = Provider.of<SignInManager>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    widget._linkHandler =
        Provider.of<FirebaseLinkHandler>(context, listen: false);
    _model = EmailPasswordSignInModel(auth: authService);

    return Scaffold(
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
                    darkMode: darkMode,
                    onPressed: signInManager.signInWithGoogle,
                  ),
                  if (appleSignInAvailable.isAvailable) ...[
                    AppleSignInButton(
                      text: 'Log in with Apple',
                      style: darkMode
                          ? AppleButtonStyle.black
                          : AppleButtonStyle.white,
                      onPressed: signInManager.signInWithApple,
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
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _passwordController,
                            validator: (password) {
                              if (password.length < 6)
                                return 'Password too short (less than 6 characters)';
                            },
                            decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        SizedBox(
                            width: Constants.column_width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                child: Text('Submit'),
                                onPressed: () async {
                                  if (!_formKey.currentState.validate()) return;
                                  await authService
                                      .signInWithEmailAndPassword(
                                          _emailController.text,
                                          _passwordController.text)
                                      .catchError((error) {
                                    widget._log.warning(
                                        'Unable to login with email/password',
                                        error);
                                  });
                                },
                              ),
                            )),
                        SizedBox(
                          width: Constants.column_width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              child: Text(
                                'no password?',
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              onTap: () {
                                _sendEmailLink();
                              },
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

  Future<void> _sendEmailLink() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      // Send link
      await widget._linkHandler.sendSignInWithEmailLink(
        email: _emailController.text,
        url: Constants.firebaseProjectURl,
        handleCodeInApp: true,
        packageName: packageInfo.packageName,
        androidInstallIfNotAvailable: true,
        androidMinimumVersion: '18',
      );
      // Tell user we sent an email
      PlatformAlertDialog(
        title: Strings.checkYourEmail,
        content: Strings.activationLinkSent(_emailController.text),
        defaultActionText: Strings.ok,
      ).show(context);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: Strings.errorSendingEmail,
        exception: e,
      ).show(context);
    }
  }
}

