import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:missionout/BLoC/bloc_provider.dart';
import 'package:missionout/BLoC/user_bloc.dart';
import 'package:missionout/DataLayer/user.dart';


class SigninScreen extends StatelessWidget {
  SigninScreen({Key key, this.title}) : super(key: key);
  final String title;

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: BlocProvider
            .of<UserBloc>(context)
            .userStream,
        builder: (context, snapshot) {
          return Scaffold(
              body: Center(
                child: GoogleSignInButton(
                  darkMode: true,
                  onPressed: _handleSignIn,
                ),)
          );
        }
    );
  }
}
