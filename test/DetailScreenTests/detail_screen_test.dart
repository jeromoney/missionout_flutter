import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/Provider/Team/team.dart';
import 'package:missionout/Provider/User/user.dart';
import 'package:missionout/UI/DetailScreen/detail_screen.dart';
import 'package:provider/provider.dart';

import '../Mock/team_fake.dart';
import '../Mock/user_fake.dart';

void main() async {
  testWidgets('DetailScreen load', (WidgetTester tester) async {
    Widget widget = MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (_) => UserFake()),
        Provider<Team>(create: (_) => TeamFake()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: DetailScreen(),
        ),
      ),
    );
    await tester.pumpWidget(widget);
  });
}
