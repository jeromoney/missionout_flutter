import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/DataLayer/user_client.dart';
import 'package:missionout/UI/overview_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
    if (!loggedIn) {
      return Center(
        child: GoogleSignInButton(
          onPressed: () {
            UserClient().handleSignIn();
          },
          darkMode: true,
        ),
      );
    } else {
      return InitWidget();
    }
  }
}

// Once the user is logged in, we still need to pull some additional information
// from firestore, so the app pauses until the operation is completed
class InitWidget extends StatefulWidget {
  @override
  State createState() => InitWidgetState();
}

class InitWidgetState extends State<InitWidget> {
  var _initialized = false;

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      return OverviewScreen();
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  void initState() {
    final user = Provider.of<FirebaseUser>(context, listen: false);
    Provider.of<ExtendedUser>(context, listen: false)
        .setUserPermissions(user)
        .then((_) => setState(() => _initialized = true));
  }
}
