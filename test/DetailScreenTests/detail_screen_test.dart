import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/Provider/database.dart';
import 'package:missionout/UI/DetailScreen/detail_screen.dart';
import 'package:provider/provider.dart';

import '../Mock/database_fake.dart';
import '../Mock/extended_user_mock.dart';
import '../Mock/firebase_mock.dart';

void main() async {
  testWidgets('DetailScreen load', (WidgetTester tester) async {
    Widget widget = MultiProvider(
      providers: [
        Provider<FirebaseUser>(create: (_) => FirebaseAuthMock()),
        Provider<ExtendedUser>(create: (_) => ExtendedUserMock()),
        Provider<Database>(create: (_) => DatabaseFake()),
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
