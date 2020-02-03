import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/UI/UserScreen/user_screen.dart';
import 'package:provider/provider.dart';

import '../Mock/firebase_mock.dart';

void main() {
  testWidgets('User screen smoke test', (WidgetTester tester) async {
    // setup

    final _user = FirebaseAuthMock();
    final _extendedUser = ExtendedUser();
    _extendedUser.mobilePhoneNumber = '+17199662421';
    _extendedUser.voicePhoneNumber = '+14154966279';



    // run test
    await tester.pumpWidget(MultiProvider(
      providers: [
        Provider<FirebaseUser>(
          create: (BuildContext context) => _user,
        ),
        Provider<ExtendedUser>(
          create: (BuildContext context) => _extendedUser,
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: UserScreen(),
        ),
      ),
    ));

    await tester.pump(Duration(microseconds: 10));

    await tester.tap(find.byType(RaisedButton));

  });
}


