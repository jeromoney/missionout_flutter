import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart'
    as flutter_auth_buttons;
import 'package:missionout/app/sign_in/sign_in_manager.dart';
import 'package:missionout/constants/constants.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:package_info/package_info.dart';
import 'package:apple_sign_in/apple_sign_in.dart' as apple;
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  static const routeName = "/login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _darkMode = false;
  bool _appleSignInAvailable = false;

  @override
  Widget build(BuildContext context) {
    final String domain = ModalRoute.of(context).settings.arguments;
    _darkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
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
            final PackageInfo packageInfo = await PackageInfo.fromPlatform();
            FirebaseAuth.instance.sendSignInWithEmailLink(
                email: "justin.matis+new@gmail.com",
                url: Constants.firebaseProjectURl,
                handleCodeInApp: true,
                iOSBundleID: packageInfo.packageName,
                androidPackageName: packageInfo.packageName,
                androidInstallIfNotAvailable: true,
                androidMinimumVersion: "18");
          },
          child: Text("[ress me"),
        ),
        Text("-----------    or     --------------"),
        flutter_auth_buttons.GoogleSignInButton(
          key: Key('Google Sign In Button'),
          onPressed: () {
            final signInManager = Provider.of<SignInManager>(context, listen: false);
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
                throw UnimplementedError("need to sign into apple");
              },
            ),
          ),
      ],
    ));
  }

  @override
  void initState() {
    super.initState();
    // check if Apple Sign In is available (i.e. only for iOS 13)
    appleSignInAvailable();
  }


  Future<void> appleSignInAvailable() async {
    bool appleSignInAvailable = await apple.AppleSignIn.isAvailable();
    setState(() {
      _appleSignInAvailable = appleSignInAvailable;
    });
  }
}
