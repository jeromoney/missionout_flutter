import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/Provider/database.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/CreateScreen/create_screen.dart';
import 'package:missionout/UI/DetailScreen/Sections/edit_detail_screen.dart';
import 'package:provider/provider.dart';

import '../../Mock/database_fake.dart';
import '../../Mock/user_fake.dart';

void main() async {
  testWidgets('Edit Detail Screen handles error', (WidgetTester tester) async {
    Widget widget = MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (_) => UserFake()),
        Provider<Database>(create: (_) => DatabaseFake()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: EditDetailScreen(
            snapshot: AsyncSnapshot.withError(ConnectionState.done, Error()),
          ),
        ),
      ),
    );
    await tester.pumpWidget(widget);
  });

  testWidgets('Edit Detail Screen handles waiting',
      (WidgetTester tester) async {
    Widget widget = MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (_) => UserFake()),
        Provider<Database>(create: (_) => DatabaseFake()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: EditDetailScreen(
            snapshot: AsyncSnapshot.withData(ConnectionState.waiting, null),
          ),
        ),
      ),
    );
    await tester.pumpWidget(widget);
  });

  testWidgets('Edit Detail Screen handles sucessful data',
      (WidgetTester tester) async {
    final mission =
        Mission('A lost puppy', 'Need snow mobilers', 'Squaw Creek', null);
    Widget widget = MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (_) => UserFake()),        Provider<Database>(create: (_) => DatabaseFake()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: EditDetailScreen(
            snapshot: AsyncSnapshot.withData(ConnectionState.done, mission),
          ),
        ),
      ),
    );
    await tester.pumpWidget(widget);
  });

  testWidgets('Edit Detail Screen handles non editor',
      (WidgetTester tester) async {
    final mission =
        Mission('A lost puppy', 'Need snow mobilers', 'Squaw Creek', null);
    Widget widget = MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (_) => UserFake(isEditor: false)),
        Provider<Database>(create: (_) => DatabaseFake()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: EditDetailScreen(
            snapshot: AsyncSnapshot.withData(ConnectionState.done, mission),
          ),
        ),
      ),
    );
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    expect(find.byType(ButtonBar), findsNothing);
  });

  testWidgets('Edit Detail Screen navigates to edit screen',
      (WidgetTester tester) async {
    final mission =
        Mission('A lost puppy', 'Need snow mobilers', 'Squaw Creek', null);
    Widget widget = MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (_) => UserFake()),
        Provider<Database>(create: (_) => DatabaseFake()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: EditDetailScreen(
            snapshot: AsyncSnapshot.withData(ConnectionState.done, mission),
          ),
        ),
      ),
    );
    await tester.pumpWidget(widget);
    var finder = find.byType(FlatButton).at(1);
    await tester.tap(finder);
    await tester.pumpAndSettle();
    expect(find.byType(CreateScreen), findsOneWidget);
  });

  testWidgets('Edit Detail Screen hits standown mission button',
      (WidgetTester tester) async {
    final mission =
        Mission('A lost puppy', 'Need snow mobilers', 'Squaw Creek', null);
    Widget widget = MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (_) => UserFake()),
        Provider<Database>(create: (_) => DatabaseFake()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: EditDetailScreen(
            snapshot: AsyncSnapshot.withData(ConnectionState.done, mission),
          ),
        ),
      ),
    );
    await tester.pumpWidget(widget);
    var finder = find.byType(FlatButton).at(2);
    await tester.tap(finder);
  });

  testWidgets('Edit Detail Screen hits page button',
      (WidgetTester tester) async {
    final mission =
        Mission('A lost puppy', 'Need snow mobilers', 'Squaw Creek', null);
    Widget widget = MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (_) => UserFake()),
        Provider<Database>(create: (_) => DatabaseFake()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: EditDetailScreen(
            snapshot: AsyncSnapshot.withData(ConnectionState.done, mission),
          ),
        ),
      ),
    );
    await tester.pumpWidget(widget);
    var finder = find.byType(FlatButton).at(0);
    await tester.tap(finder);
  });
}
