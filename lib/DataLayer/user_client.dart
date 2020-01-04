
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tuple/tuple.dart';

class UserClient {
  Future<Tuple2<FirebaseUser, HashMap<dynamic, dynamic>>> handleSignIn() async {
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

    // got the user, now get the custom claims

    final idTokenResult = await user.getIdToken();
    final claims = HashMap.from(idTokenResult.claims);
    return Tuple2(user, claims);
  }

  Future<FirebaseUser> handleSignOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    await _auth.signOut();
    return null;
  }
}
