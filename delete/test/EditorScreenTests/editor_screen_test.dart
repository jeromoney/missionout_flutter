import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/UI/EditorScreen/editor_screen.dart';
import 'package:provider/provider.dart';

import '../Mock/providers_fake.dart';


void main(){
  group('EditorScreen widget tests', (){
    testWidgets('EditorScreen widget smoke tests', (WidgetTester tester) async{
      Widget widget = MultiProvider(
        providers: PROVIDERS_FAKE,
        child: MaterialApp(home: Scaffold(body: EditorScreen())),
      );
      await tester.pumpWidget(widget);
      expect(find.text('Submit'),findsOneWidget);
    });
  });
}