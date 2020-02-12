import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/editor_screen.dart';
import 'package:provider/provider.dart';

import 'Mock/user_fake.dart';

void main(){
  group('EditorScreen widget tests', (){
    testWidgets('EditorScreen widget smoke tests', (WidgetTester tester) async{
      Widget widget = MultiProvider(
        providers: [
          ChangeNotifierProvider<User>(create: (_) => UserFake()),
        ],
        child: MaterialApp(home: Scaffold(body: EditorScreen())),
      );
      await tester.pumpWidget(widget);
      expect(find.text('editor options go here'),findsOneWidget);
    });
  });
}