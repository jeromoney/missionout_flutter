import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/Provider/team.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/response_screen.dart';
import 'package:provider/provider.dart';

import 'Mock/team_fake.dart';
import 'Mock/user_fake.dart';

void main() {
  group('ResponseScreen tests', () {
    testWidgets('ResponseScreen smoketest', (WidgetTester tester) async {
      Widget widget = MultiProvider(
        providers: [
          ChangeNotifierProvider<User>(create: (_) => UserFake()),
          Provider<Team>(create: (_) => TeamFake()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: ResponseScreen(),
          ),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
    });
  });

  group('BuildResponseStream tests', () {
    testWidgets('BuildResponseStream return one value', (WidgetTester tester) async {
      Widget widget = MultiProvider(
        providers: [
          ChangeNotifierProvider<User>(create: (_) => UserFake()),
          Provider<Team>(create: (_) => TeamFake(yieldValue: Yield.results)),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: BuildResponseStream(),
          ),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      expect(find.byType(DataTable), findsOneWidget);
    });

    testWidgets('BuildResponseStream returns error', (WidgetTester tester) async {
      Widget widget = MultiProvider(
        providers: [
          ChangeNotifierProvider<User>(create: (_) => UserFake()),
          Provider<Team>(create: (_) => TeamFake(yieldValue: Yield.error)),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: BuildResponseStream(),
          ),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      expect(find.text('There was an error.'), findsOneWidget);
    });

    testWidgets('BuildResponseStream returns zero results', (WidgetTester tester) async {
      Widget widget = MultiProvider(
        providers: [
          ChangeNotifierProvider<User>(create: (_) => UserFake()),
          Provider<Team>(create: (_) => TeamFake(yieldValue: Yield.zeroResults)),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: BuildResponseStream(),
          ),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      expect(find.text('No responses yet.'), findsOneWidget);
    });
  });

  group('BuildResponsesResult tests', () {
    // 100% coverage from tests up the widget tree. could add more.
  });
}
