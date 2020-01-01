import 'package:firebase_auth/firebase_auth.dart';

class User{
  final FirebaseUser user;
  final String TEAM_ID = 'raux5KIhuIL84bBmPSPs';

  User(FirebaseUser user): this.user = user;
}