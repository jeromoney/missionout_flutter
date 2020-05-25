import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/Provider/AuthService/auth_service.dart';
import 'package:missionout/Provider/Team/team.dart';
import 'package:missionout/Provider/User/user.dart';
import 'package:missionout/scratch/app/response_screen.dart';
import 'package:provider/provider.dart';

import 'Mock/auth_service_fake.dart';
import 'Mock/providers_fake.dart';
import 'Mock/team_fake.dart';
import 'Mock/user_fake.dart';

void main() {
  group('ResponseScreen tests', () {
    testWidgets('ResponseScreen smoketest', (WidgetTester tester) async {
      Widget widget = MultiProvider(
        providers: PROVIDERS_FAKE,
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
          ChangeNotifierProvider<AuthService>(create: (_) => AuthServiceFake()),
          ChangeNotifierProvider<User>(create: (_) => UserFake()),
          ChangeNotifierProvider<Team>(create: (_) => TeamFake(yieldValue: Yield.results)),
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
          ChangeNotifierProvider<AuthService>(create: (_) => AuthServiceFake()),
          ChangeNotifierProvider<User>(create: (_) => UserFake()),
          ChangeNotifierProvider<Team>(create: (_) => TeamFake(yieldValue: Yield.error)),
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
          ChangeNotifierProvider<AuthService>(create: (_) => AuthServiceFake()),
          ChangeNotifierProvider<User>(create: (_) => UserFake()),
          ChangeNotifierProvider<Team>(create: (_) => TeamFake(yieldValue: Yield.zeroResults)),
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
