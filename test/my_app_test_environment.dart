import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:provider/provider.dart';

import 'Mock/firebase_mock.dart';

class MyAppTest extends StatelessWidget{
  FirebaseUser user;
  final Widget screen;
  final ExtendedUser extendedUser;

   MyAppTest({Key key, this.user, @required this.screen, this.extendedUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null){
      user = FirebaseAuthMock();
    }
    return MultiProvider(
      providers: [
        Provider<FirebaseUser>(
          create: (BuildContext context) => user,
        ),
        Provider<ExtendedUser>(
          create: (BuildContext context) => extendedUser,
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: screen,
        ),
      ),
    );
  }
}