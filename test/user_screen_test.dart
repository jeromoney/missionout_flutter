import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/app/user_screen/user_screen.dart';

import 'test_providers.dart';

void main() {
  testWidgets('Verify that iOS can access advanced settings in the User Screen',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(getWidgetWithProviders(UserScreen()));
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
    await tester.pumpWidget(getWidgetWithProviders(UserScreen()));
    // Create the Finders.
    final titleFinder = find.text('Advanced');

    expect(titleFinder, findsOneWidget);

    await tester.tap(titleFinder);
    await tester.pumpAndSettle();
    expect(find.text("Override Do Not Disturb"), findsOneWidget);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  testWidgets('Verify that android can tap on android settings',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(getWidgetWithProviders(UserScreen()));
    await tester.pumpAndSettle();
    final titleFinder = find.text('Advanced');
    expect(titleFinder, findsOneWidget);
    await tester.tap(titleFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key("Android Do not disturb")));
    await tester.pumpAndSettle();
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  group('User Edit Screen Tests ', () {
    testWidgets('Tap on add phone number', (WidgetTester tester) async {
      await tester.pumpWidget(getWidgetWithProviders(UserScreen()));
      await tester.tap(find.text("Add Phone Number"));
      await tester.pumpAndSettle();
//          expect(find.text("Receive phone call"), findsOneWidget);
    });
    testWidgets('Delete phone number', (WidgetTester tester) async {
      await tester.pumpWidget(getWidgetWithProviders(UserScreen()));
      await tester.pumpAndSettle();
      expect(find.text("7195551234"), findsOneWidget);
      await tester.tap(find.byKey(const Key("Delete Phone Number")).first);
      await tester.pumpAndSettle();
      await tester.pump();
      //expect(find.text("No phone numbers"),findsOneWidget);
      //expect(find.text("7195551234"),findsNothing);
    });
  });

  group("Phone Edit Screen breakout tests", () {
    testWidgets('Enter phone number', (WidgetTester tester) async {
      await tester.pumpWidget(getWidgetWithProviders(PhoneEntry()));
      expect(find.text("too short"), findsNothing);
      await tester.enterText(find.byType(TextFormField), "510");
      await tester.pumpAndSettle();
      expect(find.text("too short"), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), "5105551234");
      await tester.pumpAndSettle();
      expect(find.text("too short"), findsNothing);

      await tester.enterText(find.byType(TextFormField), "51055512334344");
      await tester.pumpAndSettle();
      expect(find.text("too long"), findsOneWidget);

      await tester.enterText(
          find.byType(TextFormField), "sdfg2jsdher4ugb....@@rg");
      await tester.pumpAndSettle();
      expect(find.text("24"), findsOneWidget);
    });
    testWidgets("Tap on check boxes", (WidgetTester tester) async {
      await tester.pumpWidget(getWidgetWithProviders(PhoneEntry()));
      await tester.enterText(find.byType(TextFormField), "5105551234");
      await tester.pumpAndSettle();
      await tester.tap(find.text("Save"));
      await tester.pumpAndSettle();
      expect(
          find.text("At least one option must be checked"), findsNWidgets(2));
      expect(find.byType(CheckboxListTile), findsNWidgets(2));

      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text("Save"));
      await tester.pumpAndSettle();
      expect(find.text("At least one option must be checked"), findsNothing);
    });
  });
}
