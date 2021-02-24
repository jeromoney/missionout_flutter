import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/app/user_screen/user_screen.dart';
import 'package:missionout/services/team/mock_team.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/mock_user.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

final widgetWithProviders = MultiProvider(
    providers: [
      Provider<Team>(create: (_) => MockTeam()),
      ListenableProvider<User>(create: (_) => MockUser()),
    ],
    child: MaterialApp(
      home: UserScreen(),
    ));

void main() {
  testWidgets('Verify that iOS can access advanced settings in the User Screen',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(widgetWithProviders);
    // Create the Finders.
    final titleFinder = find.text('Advanced');

    expect(titleFinder, findsOneWidget);

    await tester.tap(titleFinder);
    await tester.pumpAndSettle();
    expect(find.text("Alert Sound"), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(Slider), const Offset(100, 0));
    await tester.drag(find.byType(Slider), const Offset(0, 0));
    await tester.drag(find.byType(Slider), const Offset(50, 0));

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(Slider), const Offset(100, 0));
    await tester.drag(find.byType(Slider), const Offset(0, 0));
    await tester.drag(find.byType(Slider), const Offset(50, 0));

    final dropDownMenu = find.byKey(const Key("My Dropdown Menu"));
    await tester.tap(dropDownMenu);
    await tester.pumpAndSettle();

    expect(find.text("Air raid siren"), findsWidgets);

    await tester.tap(find.text("Evil plan").last);

    await tester.pumpAndSettle();
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets(
      'Verify that android can access advanced settings in the User Screen',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(widgetWithProviders);
    // Create the Finders.
    final titleFinder = find.text('Advanced');

    expect(titleFinder, findsOneWidget);

    await tester.tap(titleFinder);
    await tester.pumpAndSettle();
    expect(find.text("I am some choices for android"), findsOneWidget);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));
}
