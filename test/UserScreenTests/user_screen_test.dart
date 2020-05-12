import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/Provider/Team/team.dart';
import 'package:missionout/Provider/User/user.dart';
import 'package:missionout/UI/UserScreen/user_screen.dart';
import 'package:provider/provider.dart';

import '../Mock/team_fake.dart';
import '../Mock/user_fake.dart';

void main() {
  group('UserScreen widget tests', () {
    testWidgets('User screen sucessful test', (WidgetTester tester) async {
      // run test
      Widget widget = MultiProvider(
        providers: [
          ChangeNotifierProvider<User>(
              create: (_) => UserFake(
                  mobilePhoneNumber: '+17199662421',
                  voicePhoneNumber: '+14154966279')),
          Provider<Team>(create: (_) => TeamFake()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: UserScreen(),
          ),
        ),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RaisedButton));
    });

    testWidgets('Erroneous Number Test', (WidgetTester tester) async {
      // setup
      Widget widget = MultiProvider(
        providers: [
          ChangeNotifierProvider<User>(
              create: (_) => UserFake(
                  mobilePhoneNumber: '+17199662421',
                  voicePhoneNumber: '+3333')),
          Provider<Team>(create: (_) => TeamFake()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: UserScreen(),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      await tester.pumpAndSettle();
      final Finder mobilePhoneNumber =
          find.widgetWithText(TextFormField, 'Mobile number');
      await tester.enterText(mobilePhoneNumber, '8791');
      await tester.pumpAndSettle();

      await tester.tap(find.byType(RaisedButton));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // Find Snackbar
      expect(find.text('Processing'), findsOneWidget);
    });
  });

  group('SubmitButton widget tests', () {
    testWidgets('SubmitButton widget tests with validated form',
        (WidgetTester tester) async {
      final someController = TextEditingController();
      final anotherController = TextEditingController();
      Widget widget = MultiProvider(
        providers: [
          ChangeNotifierProvider<User>(
              create: (_) => UserFake(
                  mobilePhoneNumber: '+17199662421',
                  voicePhoneNumber: '+14154966279')),
          Provider<Team>(create: (_) => TeamFake()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Form(
              child: SubmitButton(
                mobilePhoneNumberController: someController,
                voicePhoneNumberController: anotherController,
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RaisedButton));
    });

    testWidgets('SubmitButton widget tests with invalidated form',
        (WidgetTester tester) async {
      final someController = TextEditingController();
      final anotherController = TextEditingController();
      Widget widget = MultiProvider(
          providers: [
            ChangeNotifierProvider<User>(
                create: (_) => UserFake(
                    mobilePhoneNumber: '+17199662421',
                    voicePhoneNumber: '+14154966279')),
            Provider<Team>(create: (_) => TeamFake()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (_) => 'some error message',
                    ),
                    SubmitButton(
                      mobilePhoneNumberController: someController,
                      voicePhoneNumberController: anotherController,
                    )
                  ],
                ),
              ),
            ),
          ));

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RaisedButton));
      // Should find error snackbar
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
