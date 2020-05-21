import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/Provider/AuthService/auth_service.dart';
import 'package:missionout/Provider/Team/team.dart';
import 'package:missionout/Provider/User/user.dart';
import 'package:missionout/UI/CreateScreen/create_screen.dart';
import 'package:missionout/UI/DetailScreen/detail_screen.dart';
import 'package:missionout/UI/overview_screen.dart';
import 'package:provider/provider.dart';

import '../Mock/auth_service_fake.dart';
import '../Mock/providers_fake.dart';
import '../Mock/team_fake.dart';
import '../Mock/user_fake.dart';
import '../Mock/mission_mock.dart';

void main() async {
  group(('OverviewScreen tests'), (){
    testWidgets('OverviewScreen smoketest',
            (WidgetTester tester) async {
          // The widget tree should never pass down zero results.
          Widget widget = MultiProvider(
            providers: PROVIDERS_FAKE,
            child: MaterialApp(home: Scaffold(body: OverviewScreen())),
          );
          await tester.pumpWidget(widget);
          await tester.pumpAndSettle();
          expect(find.byType(OverviewScreen), findsOneWidget);
        });

    testWidgets('OverviewScreen shows edit FAB to editors. Tap it to navigatate to edit screen',
            (WidgetTester tester) async {
          // The widget tree should never pass down zero results.
          Widget widget = MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthService>(create: (_) => AuthServiceFake()),
              ChangeNotifierProvider<User>(create: (_) => UserFake(isEditor: true)),
              ChangeNotifierProvider<Team>(create: (_) => TeamFake()),
            ],
            child: MaterialApp(home: Scaffold(body: OverviewScreen())),
          );
          await tester.pumpWidget(widget);
          await tester.pumpAndSettle();
          expect(find.byType(FloatingActionButton), findsOneWidget);
          // press Floating Action Button and navigate to create screen
          var finder = find.byType(FloatingActionButton).first;
          await tester.tap(finder);
          await tester.pumpAndSettle();
          expect(find.byType(CreateScreen), findsOneWidget);
        });

    testWidgets('OverviewScreen does not show FAB to non-editors',
            (WidgetTester tester) async {
          // The widget tree should never pass down zero results.
          Widget widget = MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthService>(create: (_) => AuthServiceFake()),
              ChangeNotifierProvider<User>(create: (_) => UserFake(isEditor: false)),
              ChangeNotifierProvider<Team>(create: (_) => TeamFake()),
            ],
            child: MaterialApp(home: Scaffold(body: OverviewScreen())),
          );
          await tester.pumpWidget(widget);
          await tester.pumpAndSettle();
          expect(find.byType(FloatingActionButton), findsNothing);
        });
  });

  group(('BuildMissionStream tests'), () {
    testWidgets('BuildMissionStream fetches results',
            (WidgetTester tester) async {
          // The widget tree should never pass down zero results.
          Widget widget = MultiProvider(
            providers: PROVIDERS_FAKE,
            child: MaterialApp(home: Scaffold(body: BuildMissionStream())),
          );
          await tester.pumpWidget(widget);
          await tester.pumpAndSettle();
          expect(find.byType(ListTile), findsOneWidget);
        });

    testWidgets('BuildMissionStream fetches results with error',
            (WidgetTester tester) async {
          // The widget tree should never pass down zero results.
          Widget widget = MultiProvider(
            providers: [
              ChangeNotifierProvider<User>(create: (_) => UserFake()),
              ChangeNotifierProvider<Team>(
                  create: (_) => TeamFake(yieldValue: Yield.error)),
            ],
            child: MaterialApp(home: Scaffold(body: BuildMissionStream())),
          );
          await tester.pumpWidget(widget);
          await tester.pumpAndSettle();
          expect(find.text('There was an error.'), findsOneWidget);
        });

    testWidgets('BuildMissionStream fetches, but no results',
            (WidgetTester tester) async {
          // The widget tree should never pass down zero results.
          Widget widget = MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthService>(create: (_) => AuthServiceFake()),
              ChangeNotifierProvider<User>(create: (_) => UserFake()),
              ChangeNotifierProvider<Team>(
                create: (_) => TeamFake(yieldValue: Yield.zeroResults),
              ),
            ],
            child: MaterialApp(home: Scaffold(body: BuildMissionStream())),
          );
          await tester.pumpWidget(widget);
          await tester.pumpAndSettle();
          expect(find.text('No recent results.'), findsOneWidget);
        });
  });

  group('BuildMissionResults tests', () {
    testWidgets('BuildMissionResults displays zero results',
        (WidgetTester tester) async {
      // The widget tree should never pass down zero results.
      List<Mission> missions = [];
      Widget widget = Directionality(
          textDirection: TextDirection.ltr,
          child: BuildMissionResults(
            missions: missions,
          ));
      await tester.pumpWidget(widget);
      // expect
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('BuildMissionResults displays one results',
        (WidgetTester tester) async {
      // The widget tree should never pass down zero results.
      final mission = Mission('Hello', 'Mango', 'Need papaya', null);
      List<Mission> missions = [mission];
      Widget widget = MaterialApp(
          home: Scaffold(
              body: BuildMissionResults(
        missions: missions,
      )));
      await tester.pumpWidget(widget);
      // expect
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('BuildMissionResults displays 5 results',
        (WidgetTester tester) async {
      // The widget tree should never pass down zero results.
      final mission = Mission('Hello', 'Mango', 'Need papaya', null);
      List<Mission> missions = [mission, mission, mission, mission, mission];
      Widget widget = MultiProvider(
        providers: PROVIDERS_FAKE,
        child: MaterialApp(
            home: Scaffold(
                body: BuildMissionResults(
          missions: missions,
        ))),
      );

      await tester.pumpWidget(widget);
      // expect
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(5));
      expect(find.text('Hello'), findsNWidgets(5));
    });

    testWidgets('BuildMissionResults navigates to detail screen',
        (WidgetTester tester) async {
      // The widget tree should never pass down zero results.
      final mission = MissionMock();
      List<Mission> missions = [mission, mission, mission, mission, mission];
      Widget widget = MultiProvider(
        providers: PROVIDERS_FAKE,
        child: MaterialApp(
          home: Scaffold(
              body: BuildMissionResults(
            missions: missions,
          )),
          routes: {
            '/detail': (context) => DetailScreen(),
          },
        ),
      );

      await tester.pumpWidget(widget);
      // click on mission and navigate to detail screen
      var finder = find.byType(ListTile).first;
      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(find.byType(DetailScreen), findsOneWidget);
    });
  });

}
