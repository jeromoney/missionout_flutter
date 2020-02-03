import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/UI/UserScreen/phone_entry.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Phone Entry Widge smoke test', (WidgetTester tester) async {
    final _phoneType = PhoneType.voicePhoneNumber;
    final _extendedUser = ExtendedUser();
    final _controller = TextEditingController();
    _extendedUser.mobilePhoneNumber = '+17199662421';
    _extendedUser.voicePhoneNumber = '+14154966279';

    await tester.pumpWidget(MultiProvider(
      providers: [
        Provider<ExtendedUser>(
          create: (BuildContext context) => _extendedUser,
        ),
        Provider<PhoneType>(
          create: (BuildContext context) => _phoneType,
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
    expect(find.text('+17199662421'),findsNothing);
    expect(find.text('+14154966279'),findsOneWidget);
    await tester.pump(Duration(seconds: 2));
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(find.text('+14154966279'),findsNothing);
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(find.text('+14154966279'),findsOneWidget);
  });
}
