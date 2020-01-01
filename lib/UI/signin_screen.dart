import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:missionout/UI/overview_screen.dart';



class SigninScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: <Widget>[
            MaterialButton(
              child: Icon(Icons.restaurant),
              onPressed: () {
                _handleSignIn();
//                    .then((FirebaseUser user) => print(user))
//                    .catchError((e) => print(e));
              },
            ),
            MaterialButton(
              child: Icon(Icons.dashboard),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => OverviewScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<FirebaseUser> _handleSignIn() async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.accessToken, accessToken: googleAuth.idToken);

  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  print("signed in " + user.displayName);
  return user;
}
