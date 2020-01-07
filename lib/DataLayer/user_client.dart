import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tuple/tuple.dart';
import 'dart:io' show Platform;


class UserClient {

  Future<FirebaseUser> fetchCurrentUser() async{
   return await FirebaseAuth.instance.currentUser();
  }

  Future<Tuple2<FirebaseUser, HashMap<dynamic, dynamic>>> handleSignIn() async {
    //check if user is signed in
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

    addTokenToFirestore(user);

    return Tuple2(user, claims);
  }

  Future<void> addTokenToFirestore(FirebaseUser user) async {
    // Setting up the user will be the responsibility of the server.
    // This method adds the user token to firestore
    final idToken = await user.getIdToken();
    final data = {
      'token': idToken.token,
      'platform': Platform.operatingSystem,
      'createdAt': FieldValue.serverTimestamp()
    };
    final DocumentReference document = await Firestore.instance
        .collection('users/${user.uid}/tokens')
        .document(idToken.token)
        .setData(data)
        .then((value) {
      debugPrint('hello world');
    }).catchError((error) {
      debugPrint('there was an error');
    });
  }

  Future<FirebaseUser> handleSignOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    await _auth.signOut();
    return null;
  }
}
