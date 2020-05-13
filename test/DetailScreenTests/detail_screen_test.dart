import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/Provider/Team/team.dart';
import 'package:missionout/Provider/User/user.dart';
import 'package:missionout/UI/DetailScreen/detail_screen.dart';
import 'package:provider/provider.dart';

import '../Mock/providers_fake.dart';

void main() async {
  testWidgets('DetailScreen load', (WidgetTester tester) async {
    Widget widget = MultiProvider(
      providers: PROVIDERS_FAKE,
      child: MaterialApp(
        home: Scaffold(
          body: DetailScreen(),
        ),
      ),
    );
    await tester.pumpWidget(widget);
  });
}
