import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/DataLayer/app_mode.dart';
import 'package:missionout/Provider/team.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/overview_screen.dart';
import 'package:missionout/UI/signin_screen.dart';
import 'package:missionout/main.dart';
import 'package:provider/provider.dart';

import '../Mock/team_fake.dart';
import '../Mock/user_fake.dart';

void main() {
  testWidgets('Sign in user and then sign out', (WidgetTester tester) async {
    final providers = [
      ChangeNotifierProvider<AppMode>(
        create: (_) => AppMode(),
      ),
          ChangeNotifierProvider<User>(
              create: (_) => UserFake(signedIn: false)),
          Provider<Team>(create: (_) => TeamFake()),
        ];

    Widget widget = MissionOut(providers: providers,);
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    // sign in
    final signInButton = find.byKey(Key('Google Sign In Button'));
    expect(signInButton, findsOneWidget);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();
    expect(find.byType(OverviewScreen), findsOneWidget);
    // tap on options menu
    final optionsMenu = find.byKey(Key('PopupMenuButton'));
    expect(optionsMenu, findsOneWidget);
    await tester.tap(optionsMenu);
    await tester.pumpAndSettle();
    // tap on sign out
    final signOutButton = find.text('Sign out');
    expect(signOutButton, findsOneWidget);
    await tester.tap(signOutButton);
    await tester.pumpAndSettle();
    // confirm sign out
    final signOutAlertButton = find.text('Sign out');
    expect(signOutAlertButton, findsOneWidget);
    await tester.tap(signOutAlertButton);
    await tester.pumpAndSettle();
    // back at sign in screen
    expect(find.byType(SigninScreen), findsOneWidget);
  });
}
