import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/UI/DetailScreen/detail_screen.dart';
import 'package:missionout/utils/utils.dart';


void main() {
  test('formatTime test', () {
    Timestamp timestamp;
    var result = formatTime(timestamp);
    expect(result, '');
    timestamp = Timestamp.fromMicrosecondsSinceEpoch(0);
    result = formatTime(timestamp);
    expect(result, '1969-12-31 17:00');
  });

  testWidgets('Info screen handles error', (WidgetTester tester) async {
    Widget widget = Directionality(
        textDirection: TextDirection.ltr,
        child: InfoDetail(
          snapshot: AsyncSnapshot.withError(ConnectionState.done, Error()),
        ));
    await tester.pumpWidget(widget);
    expect(find.text('There was an error.'), findsOneWidget);
  });

  testWidgets('Info screen handles waiting', (WidgetTester tester) async {
    Widget widget = Directionality(
        textDirection: TextDirection.ltr,
        child: InfoDetail(
          snapshot: AsyncSnapshot.withError(ConnectionState.waiting, null),
        ));
    await tester.pumpWidget(widget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('Info screen handles mission with data',
      (WidgetTester tester) async {
    final mission =
        Mission('A lost puppy', 'Need snow mobilers', 'Squaw Creek', null);
    AsyncSnapshot snapshot =
        AsyncSnapshot.withData(ConnectionState.done, mission);

    Widget widget = Directionality(
        textDirection: TextDirection.ltr,
        child: InfoDetail(
          snapshot: snapshot,
        ));
    await tester.pumpWidget(widget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.text('A lost puppy'), findsOneWidget);
    expect(find.text('Need snow mobilers'), findsOneWidget);
    expect(find.text('Squaw Creek'), findsOneWidget);
  });

  testWidgets('Info screen handles mission that is stood down',
      (WidgetTester tester) async {
    final mission =
        Mission('A lost puppy', 'Need snow mobilers', 'Squaw Creek', null);
    mission.isStoodDown = true;
    AsyncSnapshot snapshot =
        AsyncSnapshot.withData(ConnectionState.done, mission);

    Widget widget = Directionality(
        textDirection: TextDirection.ltr,
        child: InfoDetail(
          snapshot: snapshot,
        ));
    await tester.pumpWidget(widget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.text('A lost puppy'), findsOneWidget);
    expect(find.text('Need snow mobilers'), findsOneWidget);
    // Need snowmobilers should be crossed out
    var finder = find.text('Need snow mobilers').first.evaluate();
    var standDownText = finder.first.widget as Text;
    expect(standDownText.style,
        TextStyle(inherit: true, decoration: TextDecoration.lineThrough));
    expect(find.text('Squaw Creek'), findsOneWidget);
  });
  return;
}
