import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart'
    as flutter_auth_buttons;
import 'package:missionout/app/sign_in/sign_in_manager.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:missionout/constants/constants.dart';
import 'package:missionout/common_widgets/platform_exception_alert_dialog.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/services/firebase_email_link_handler.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "/loginScreen";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _darkMode = false;
  bool _appleSignInAvailable = false;
  bool _showPasswordField = false;
  String _domain;

  @override
  Widget build(BuildContext context) {
    _domain = ModalRoute.of(context).settings.arguments;
    _darkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final signInManager = Provider.of<SignInManager>(context, listen: false);
    return Scaffold(
        key: widget._scaffoldKey,
        body: Center(
          child: LayoutBuilder(
            builder: (context, viewportConstraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: Constants.column_width,
                    minHeight: viewportConstraints.minHeight),
                child: Form(
                  key: widget._formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: Column(
                          children: <Widget>[
                            flutter_auth_buttons.GoogleSignInButton(
                              key: Key('Google Sign In Button'),
                              onPressed: signInManager.signInWithGoogle,
                              darkMode: _darkMode,
                            ),
                            if (_appleSignInAvailable)
                              Container(
                                child: flutter_auth_buttons.AppleSignInButton(
                                  style: _darkMode
                                      ? flutter_auth_buttons
                                          .AppleButtonStyle.black
                                      : flutter_auth_buttons
                                          .AppleButtonStyle.white,
                                  onPressed: signInManager.signInWithApple,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: Constants.column_width / 2,
                            child: TextFormField(
                              validator: (email) {
                                // The "@" can technically be in a username,
                                // but I think that is unlikely. I'm trying to
                                // people from entering their full email address.
                                if (email.contains('@')) return 'Invalid user name';
                              },
                              controller: widget._emailController,
                              decoration: InputDecoration(
                                  labelText: "email user name",
                                  hintText: "your.name",
                                  border: UnderlineInputBorder()),
                            ),
                          ),
                          Text(
                            "@$_domain",
                          ),
                        ],
                      ),
                      if (_showPasswordField) ...[
                        TextFormField(
                          controller: widget._passwordController,
                          decoration: InputDecoration(
                              labelText: "password",
                              border: UnderlineInputBorder()),
                          validator: (password) {
                            if (password.length < 6)
                              return Strings.invalidPasswordTooShort;
                          },
                        ),
                      ],
                      OutlineButton(
                        onPressed: _sendEmailLink,
                        onLongPress: _showPasswordMethod,
                        child: Text(!_showPasswordField
                            ? "Email login"
                            : "Create login with password"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Future _sendEmailLink() async {
    if (!widget._formKey.currentState.validate()) return;
    final linkHandler =
        Provider.of<FirebaseEmailLinkHandler>(context, listen: false);
    final email = "${widget._emailController.text}@$_domain";
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      await linkHandler.sendSignInWithEmailLink(
          email: email,
          url: Constants.firebaseProjectURl,
          handleCodeInApp: true,
          packageName: packageInfo.packageName,
          androidInstallIfNotAvailable: true,
          androidMinimumVersion: "18");

      PlatformAlertDialog(
        title: "Check your email",
        content: "sent to email to $email",
        defaultActionText: "Ok",
      ).show(context);
    } on PlatformException catch (error) {
      PlatformExceptionAlertDialog(
              title: "Error sending email", exception: error)
          .show(context);
    }
  }

  void _showPasswordMethod() {
    String snackbarText;
    if (!_showPasswordField)
      snackbarText = "Accessing hidden password field";
    else
      snackbarText = "Hiding password field";
    final snackbar = SnackBar(
      content: Text(snackbarText),
    );
    widget._scaffoldKey.currentState.showSnackBar(snackbar);
    setState(() => _showPasswordField = !_showPasswordField);
  }
}
