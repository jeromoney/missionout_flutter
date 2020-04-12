import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/UserScreen/user_screen.dart';
import 'package:provider/provider.dart';

import '../Mock/user_fake.dart';

void main() {
  testWidgets('Phone Entry Widge smoke test', (WidgetTester tester) async {
    final _controller = TextEditingController();

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(
          create: (_) => UserFake(
              mobilePhoneNumber: '+17199662421',
              voicePhoneNumber: '+14154966279'),
        ),
        Provider<PhoneType>(
          create: (BuildContext context) => PhoneType.voicePhoneNumber,
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: PhoneEntry(
            controller: _controller,
          ),
        ),
      ),
    ));
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
      Widget widget = MaterialApp(
          home: Scaffold(
        body: InternationalPhoneNumberInputFutureBuilder(
          controller: null,
          labelText: null,
          snapshot: AsyncSnapshot.withError(
              ConnectionState.done, DiagnosticLevel.error),
          hintText: null,
        ),
      ));
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      // In error, the widget should just use the default region of US
      // TODO - verify error handling works as it should
    });

    testWidgets(
        'InternationalPhoneNumberInputFutureBuilder widget with sucessful snapshot',
        (WidgetTester tester) async {
      Widget widget = MaterialApp(
          home: Scaffold(
        body: InternationalPhoneNumberInputFutureBuilder(
          controller: null,
          labelText: null,
          snapshot: AsyncSnapshot.withData(ConnectionState.done, 'US'),
          hintText: null,
        ),
      ));
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

  group('getRegion unit testing', (){
    test('testing different values', () async{
      expect(await getRegion(''), 'US');
      expect(await getRegion(null), 'US');
      // expect(await getRegion('+12122535678'), 'US'); //TODO - fix. Unable to run this outside of an app
    });
  });
}
