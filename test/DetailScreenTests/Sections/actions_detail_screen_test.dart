import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/UI/DetailScreen/Sections/actions_detail_screen.dart';
import 'package:provider/provider.dart';

import '../../Mock/extended_user_mock.dart';

void main() async {
  testWidgets('action segment handles error', (WidgetTester tester) async {
    Widget widget = MultiProvider(
      providers: [Provider(create: (_) => ExtendedUser())],
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
      providers: [Provider(create: (_) => ExtendedUser())],
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
      providers: [Provider(create: (_) => ExtendedUserMock(chatURI: 'https://www.cnn.com/'))],
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
    // tap on message iconE
    var finder = find.byType(IconButton).at(0);
    await tester.tap(finder);
    await tester.pumpAndSettle();

    // tap on map icon
    finder = find.byType(IconButton).at(1);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  });

  testWidgets('action segment handles mission without location',
      (WidgetTester tester) async {
    final mission =
        Mission('A lost puppy', 'Need snow mobilers', 'Squaw Creek', null);
    Widget widget = MultiProvider(
      providers: [Provider(create: (_) => ExtendedUser())],
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
}
