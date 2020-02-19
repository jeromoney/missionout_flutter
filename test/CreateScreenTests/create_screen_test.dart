import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/DataLayer/mission_address.dart';
import 'package:missionout/Provider/team.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/CreateScreen/create_screen.dart';
import 'package:provider/provider.dart';

import '../Mock/team_fake.dart';
import '../Mock/user_fake.dart';

void main() {
  group('CreateSreen widget tests', () {
    testWidgets('CreateSreen widget test validation',
        (WidgetTester tester) async {
      final _formKey = GlobalKey<FormState>();
      Widget widget = MultiProvider(
          providers: [
            ChangeNotifierProvider<User>(create: (_) => UserFake()),
            Provider<Team>(create: (_) => TeamFake()),
            Provider<MissionAddress>(create: (_) => MissionAddress(),)
          ],
          child:MaterialApp(
        home: Scaffold(
          body: Form(key: _formKey, child: CreateScreen()),
        ),
      ));
      await tester.pumpWidget(widget)
      ;
      expect(find.text('Description'), findsOneWidget);
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      expect(find.text('Description required'), findsOneWidget);
    });
  });
}
