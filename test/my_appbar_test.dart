import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/UserScreen/user_screen.dart';
import 'package:missionout/UI/editor_screen.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:provider/provider.dart';

import 'Mock/user_fake.dart';

void main() {
  group('MyAppbar widget tests', () {
    testWidgets('MyAppbar widget smoke test', (WidgetTester tester) async {
      Widget widget = MultiProvider(
        providers: [
          ChangeNotifierProvider<User>(create: (_) => UserFake()),
        ],
        child: MaterialApp(
            home: Scaffold(
                body: MyAppBar(
          title: 'something',
        ))),
      );
      await tester.pumpWidget(widget);
      expect(find.text('something'), findsOneWidget);
    });

    testWidgets('MyAppbar widget tap on sign out button',
        (WidgetTester tester) async {
      Widget widget = MultiProvider(
        providers: [
          ChangeNotifierProvider<User>(create: (_) => UserFake()),
        ],
        child: MaterialApp(
            home: Scaffold(
                body: MyAppBar(
          title: 'something',
        ))),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      var finder = find.byKey(Key('PopupMenuButton'));
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      finder = find.text('Sign out');
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      finder = find.byType(AlertDialog);
      finder = find.text('Sign out');
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('MyAppbar widget tap on user options button',
        (WidgetTester tester) async {
      Widget widget = MultiProvider(
        providers: [
          ChangeNotifierProvider<User>(create: (_) => UserFake()),
        ],
        child: MaterialApp(
            home: Scaffold(
                body: MyAppBar(
          title: 'something',
        ))),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      var finder = find.byKey(Key('PopupMenuButton'));
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      finder = find.text('User Options');
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(find.byType(UserScreen), findsOneWidget);
    });

    testWidgets('MyAppbar widget tap on editor options button',
        (WidgetTester tester) async {
      Widget widget = MultiProvider(
        providers: [
          ChangeNotifierProvider<User>(create: (_) => UserFake()),
        ],
        child: MaterialApp(
            home: Scaffold(
                body: MyAppBar(
          title: 'something',
        ))),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      var finder = find.byKey(Key('PopupMenuButton'));
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      finder = find.text('Editor Options');
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(find.byType(EditorScreen), findsOneWidget);
    });
  });
}
