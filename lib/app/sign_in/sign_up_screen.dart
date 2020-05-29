import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart'
    as flutter_auth_buttons;
import 'package:missionout/app/sign_in/sign_in_manager.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:missionout/constants/constants.dart';
import 'package:missionout/common_widgets/platform_exception_alert_dialog.dart';
import 'package:missionout/services/firebase_email_link_handler.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "/loginScreen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _darkMode = false;
  bool _appleSignInAvailable = false;

  @override
  Widget build(BuildContext context) {
    final String domain = ModalRoute.of(context).settings.arguments;
    _darkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final signInManager =
    Provider.of<SignInManager>(context, listen: false);
    return Scaffold(
        body: Column(
      children: <Widget>[
        Text(domain),
        TextFormField(
          decoration: InputDecoration(border: UnderlineInputBorder()),
        ),
        TextFormField(
          decoration: InputDecoration(border: UnderlineInputBorder()),
        ),
        OutlineButton(
          onPressed: () async {
            _sendEmailLink();
          },
          child: Text("Press me"),
        ),OutlineButton(
          onPressed: () async {
            final linkHandler = Provider.of<FirebaseEmailLinkHandler>(context, listen: false);

          },
          child: Text("Check for user"),
        ),
        Text("-----------    or     --------------"),
        flutter_auth_buttons.GoogleSignInButton(
          key: Key('Google Sign In Button'),
          onPressed: () {
            signInManager.signInWithGoogle();
          },
          darkMode: _darkMode,
        ),
        if (_appleSignInAvailable)
          Container(
            child: flutter_auth_buttons.AppleSignInButton(
              style: _darkMode
                  ? flutter_auth_buttons.AppleButtonStyle.black
                  : flutter_auth_buttons.AppleButtonStyle.white,
              onPressed: () {
                signInManager.signInWithApple();
              },
            ),
          ),
      ],
    ));
  }

  Future _sendEmailLink() async {
    final linkHandler = Provider.of<FirebaseEmailLinkHandler>(context, listen: false);
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      await linkHandler.sendSignInWithEmailLink(
          email: "justin.matis+dfhdkfg@gmail.com",
          url: Constants.firebaseProjectURl,
          handleCodeInApp: true,
          packageName: packageInfo.packageName,
          androidInstallIfNotAvailable: true,
          androidMinimumVersion: "18");

      PlatformAlertDialog(
        title: "Check your email",
        content: "sent to email to you johnny",
        defaultActionText: "Ok",
      ).show(context);
    } on PlatformException catch (error) {
      PlatformExceptionAlertDialog(
              title: "Error sending email", exception: error)
          .show(context);
    }
  }
}
