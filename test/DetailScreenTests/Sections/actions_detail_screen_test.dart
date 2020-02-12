import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/mission_address.dart';
import 'package:missionout/Provider/database.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/DetailScreen/Sections/actions_detail_screen.dart';
import 'package:missionout/UI/response_screen.dart';
import 'package:provider/provider.dart';

import '../../Mock/database_fake.dart';
import '../../Mock/user_fake.dart';

void main() async {
  group('ActionDetailScreen tests', (){testWidgets('action segment handles error', (WidgetTester tester) async {
    Widget widget = MultiProvider(
      providers: [ChangeNotifierProvider<User>(create: (_) => UserFake())],
      child: MaterialApp(
        home: Scaffold(
          body: ActionsDetailScreen(
            snapshot: AsyncSnapshot.withError(ConnectionState.done, Error()),
          ),
        ),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.text('There was an error.'), findsOneWidget);
  });

  testWidgets('action segment handles waiting', (WidgetTester tester) async {
    Widget widget = MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (_) => UserFake()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: ActionsDetailScreen(
            snapshot: AsyncSnapshot.withData(ConnectionState.waiting, null),
          ),
        ),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.byType(IconButton), findsNWidgets(3));
  });

  testWidgets('action segment handles mission with location',
          (WidgetTester tester) async {
        final mission = Mission('A lost puppy', 'Need snow mobilers', 'Squaw Creek',
            GeoPoint(2.3, 22.3));
        Widget widget = MultiProvider(
          providers: [
            Provider<Database>(
              create: (_) => DatabaseFake(),
            ),
            ChangeNotifierProvider<User>(
                create: (_) => UserFake(chatURI: 'https://www.cnn.com/')),
            Provider<MissionAddress>(create: (_)=> MissionAddress(),)
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ActionsDetailScreen(
                snapshot: AsyncSnapshot.withData(ConnectionState.done, mission),
              ),
            ),
          ),
        );
        await tester.pumpWidget(widget);
        expect(find.byType(Icon), findsNWidgets(3));
        // tap on message icon
        var finder = find.byType(IconButton).at(0);
        await tester.tap(finder);
        await tester.pumpAndSettle();

        // tap on map icon
        finder = find.byType(IconButton).at(1);
        await tester.tap(finder);
        await tester.pumpAndSettle();

        // tap on response icon
        finder = find.byType(IconButton).at(2);
        await tester.tap(finder);
        await tester.pumpAndSettle();
        expect(find.byType(ResponseScreen), findsOneWidget);
      });

  testWidgets('action segment handles mission without location',
          (WidgetTester tester) async {
        final mission =
        Mission('A lost puppy', 'Need snow mobilers', 'Squaw Creek', null);
        Widget widget = MultiProvider(
          providers: [ChangeNotifierProvider<User>(create: (_) => UserFake())],
          child: MaterialApp(
            home: Scaffold(
              body: ActionsDetailScreen(
                snapshot: AsyncSnapshot.withData(ConnectionState.done, mission),
              ),
            ),
          ),
        );
        await tester.pumpWidget(widget);
        expect(find.byType(Icon), findsNWidgets(3));
      });

  testWidgets('action segment handles chatURI error',
          (WidgetTester tester) async {
        final mission = Mission('A lost puppy', 'Need snow mobilers', 'Squaw Creek',
            GeoPoint(2.3, 22.3));
        Widget widget = MultiProvider(
          providers: [
            ChangeNotifierProvider<User>(
                create: (_) =>
                    UserFake(chatURI: 'this will cause an error'))
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ActionsDetailScreen(
                snapshot: AsyncSnapshot.withData(ConnectionState.done, mission),
              ),
            ),
          ),
        );
        await tester.pumpWidget(widget);
        expect(find.byType(Icon), findsNWidgets(3));
        // tap on message icon
        var finder = find.byType(IconButton).at(0);
        await tester.tap(finder);
        await tester.pumpAndSettle();
        expect(find.byType(SnackBar), findsOneWidget); // snackbar shows error
      });});

  group('ResponseOptions tests', (){testWidgets('ResponseOptions test', (WidgetTester tester) async {
    Widget widget = MultiProvider(
      providers: [
        Provider<Database>(
          create: (_) => DatabaseFake(),
        ),
        ChangeNotifierProvider<User>(
            create: (_) =>
                UserFake(chatURI: 'this will cause an error')),
        Provider<MissionAddress>(
          create: (_) => MissionAddress(),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: ResponseOptions(),
        ),
      ),
    );
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    var finder = find.byType(ChoiceChip);
    expect(finder, findsNWidgets(4));

    finder = find.byType(ChoiceChip).at(0);
    await tester.tap(finder);
    await tester.pumpAndSettle();

    await tester.tap(finder);
    await tester.pumpAndSettle();
  });});
}
