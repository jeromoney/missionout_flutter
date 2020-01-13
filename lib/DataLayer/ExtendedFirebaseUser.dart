import 'package:firebase_auth/firebase_auth.dart';

class ExtendedFirebaseUser {
  ExtendedFirebaseUser(FirebaseUser user) : this.user = user;
  final user;
}
