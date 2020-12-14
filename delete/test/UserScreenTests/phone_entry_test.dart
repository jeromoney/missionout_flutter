import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:missionout/UI/UserScreen/user_screen.dart';
import 'package:provider/provider.dart';

import '../Mock/providers_fake.dart';

void main() {
  testWidgets('Phone Entry Widge smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
          providers: PROVIDERS_FAKE, child: MaterialApp(home: PhoneEntry())),
    );
    expect(find.text('+17199662421'), findsNothing);
    expect(find.text('+14154966279'), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(find.text('+14154966279'), findsNothing);
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(find.text('+14154966279'), findsOneWidget);

    final Finder textEntry = find.widgetWithText(TextFormField, 'Voice number');
    await tester.enterText(textEntry, '+34343');
  });

  group('InternationalPhoneNumberInputFutureBuilder widget tests', () {
    testWidgets(
        'InternationalPhoneNumberInputFutureBuilder widget with error snapshot',
        (WidgetTester tester) async {
      Widget widget = MultiProvider(
        providers: PROVIDERS_FAKE,
        child: MaterialApp(
            home: Scaffold(
          body: MyInternationalPhoneNumberInput(),
        )),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      // In error, the widget should just use the default region of US
      // TODO - verify error handling works as it should
    });

    testWidgets(
        'InternationalPhoneNumberInputFutureBuilder widget with sucessful snapshot',
        (WidgetTester tester) async {
      Widget widget = MultiProvider(
        providers: PROVIDERS_FAKE,
        child: MaterialApp(
            home: Scaffold(
          body: MyInternationalPhoneNumberInput(),
        )),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      // In error, the widget should just use the default region of US
      // TODO - verify sucessful handling of data
      var finder = find.byType(InternationalPhoneNumberInput);
      await tester.enterText(finder, 'a');
      await tester.pumpAndSettle();
      // TODO - app should do something with the phone number
    });
  });
}
