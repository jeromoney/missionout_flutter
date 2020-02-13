import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/DataLayer/mission_address.dart';
import 'package:missionout/Provider/database.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/DetailScreen/detail_screen.dart';
import 'package:provider/provider.dart';

import '../Mock/database_fake.dart';
import '../Mock/user_fake.dart';

void main() async {
  testWidgets('DetailScreen load', (WidgetTester tester) async {
    Widget widget = MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (_) => UserFake()),
        Provider<Database>(create: (_) => DatabaseFake()),
        Provider<MissionAddress>(create: (_) => MissionAddress(),)
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