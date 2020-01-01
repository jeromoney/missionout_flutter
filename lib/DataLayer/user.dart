import 'package:firebase_auth/firebase_auth.dart';

class User{
  final FirebaseUser user;
  User(FirebaseUser user): this.user = user;
}