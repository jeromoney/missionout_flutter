import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/UI/UserScreen/user_screen.dart';

import '../my_app_test_environment.dart';

void main() {
  testWidgets('User screen sucessful test', (WidgetTester tester) async {
    // setup

    final _extendedUser = ExtendedUser();
    _extendedUser.mobilePhoneNumber = '+17199662421';
    _extendedUser.voicePhoneNumber = '+14154966279';

    // run test
    await tester.pumpWidget(MyAppTest(
      screen: UserScreen(),
      extendedUser: _extendedUser,
    ));

    await tester.pump(Duration(microseconds: 10));

    await tester.tap(find.byType(RaisedButton));
  });

  testWidgets('Erroneous Number Test', (WidgetTester tester) async {
    // setup

    final _extendedUser = ExtendedUser();
    _extendedUser.mobilePhoneNumber = '+17199662421';
    _extendedUser.voicePhoneNumber = '+3333';

    // run test
    await tester.pumpWidget(MyAppTest(
      screen: UserScreen(),
      extendedUser: _extendedUser,
    ));


    await tester.pump(Duration(microseconds: 10));

    final Finder mobilePhoneNumber =
        find.widgetWithText(TextFormField, 'Mobile number');
    await tester.enterText(mobilePhoneNumber, '8791');
    await tester.pump(Duration(microseconds: 10));

    await tester.tap(find.byType(RaisedButton));
    await tester.pump(Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Find Snackbar
    expect(find.text('Processing'), findsOneWidget);
  });
}
