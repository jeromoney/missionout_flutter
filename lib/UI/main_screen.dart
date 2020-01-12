import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:missionout/Provider/user_bloc.dart';
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
            UserBloc().handleSignIn();
          }, darkMode: true,),
      );
    } else {
      return OverviewScreen();
    }
  }
}
