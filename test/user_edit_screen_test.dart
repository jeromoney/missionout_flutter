import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/app/user_edit_screen/user_edit_screen.dart';

import 'test_providers.dart';

void main() {
  group('User Edit Screen Tests ', () {
    testWidgets('Smoke Test', (WidgetTester tester) async {
      await tester.pumpWidget(getWidgetWithProviders(UserEditScreen()));
      expect(find.text("Joe Blow"), findsOneWidget);
    });

    testWidgets('Change display name',
        (WidgetTester tester) async {
      await tester.pumpWidget(getWidgetWithProviders(UserEditScreen()));
      await tester.enterText(find.text("Joe Blow"), "Joe Exotic");
      expect(find.text("Joe Exotic"), findsOneWidget);
      await tester.tap(find.text("Save"));
      await tester.pumpAndSettle();

    });
    testWidgets('Tap on add phone number',
            (WidgetTester tester) async {
          await tester.pumpWidget(getWidgetWithProviders(UserEditScreen()));
          await tester.tap(find.text("Add Phone Number"));
          await tester.pumpAndSettle();
//          expect(find.text("Receive phone call"), findsOneWidget);
        });
    testWidgets('Delete phone number', (WidgetTester tester) async {
      await tester.pumpWidget(getWidgetWithProviders(UserEditScreen()));
      await tester.pumpAndSettle();
      expect(find.text("7195551234"),findsOneWidget);
      await tester.tap(find.byKey(const Key("Delete Phone Number")).first);
      await tester.pumpAndSettle();
      await tester.pump();
      //expect(find.text("No phone numbers"),findsOneWidget);
      //expect(find.text("7195551234"),findsNothing);


    });


  });

  group("Phone Edit Screen breakout tests", (){
    testWidgets('Enter phone number',
            (WidgetTester tester) async {
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

          await tester.enterText(find.byType(TextFormField), "sdfg2jsdher4ugb....@@rg");
          await tester.pumpAndSettle();
          expect(find.text("24"), findsOneWidget);
            });
    testWidgets("Tap on check boxes", (WidgetTester tester) async{
      await tester.pumpWidget(getWidgetWithProviders(PhoneEntry()));
      await tester.enterText(find.byType(TextFormField), "5105551234");
      await tester.pumpAndSettle();
      await tester.tap(find.text("Save"));
      await tester.pumpAndSettle();
      expect(find.text("At least one option must be checked"), findsNWidgets(2));
      expect(find.byType(CheckboxListTile),findsNWidgets(2));

      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text("Save"));
      await tester.pumpAndSettle();
      expect(find.text("At least one option must be checked"), findsNothing);
    });
  });
}
