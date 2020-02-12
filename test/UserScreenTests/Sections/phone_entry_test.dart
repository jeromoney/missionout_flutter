import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/UserScreen/Sections/phone_entry.dart';
import 'package:provider/provider.dart';

import '../../Mock/user_fake.dart';

void main() {
  testWidgets('Phone Entry Widge smoke test', (WidgetTester tester) async {
    final _controller = TextEditingController();

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(
          create: (_) => UserFake(mobilePhoneNumber: '+17199662421',voicePhoneNumber: '+14154966279'),
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
}
