import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/UI/EditorScreen/editor_screen.dart';

void main() {
  testWidgets('UriTextFormField widget smoke test',
      (WidgetTester tester) async {
    Widget widget = MaterialApp(
      home: Scaffold(
        body: URITextFormField(
          controller: null,
        ),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.text('Try URI'), findsOneWidget);
  });

  testWidgets('UriTextFormField widget tap on URI verify button with erroneous field',
      (WidgetTester tester) async {
    final controller = TextEditingController();
    controller.text = 'throw an error';
    Widget widget = MaterialApp(
      home: Scaffold(
        body: URITextFormField(
          controller: controller,
        ),
      ),
    );
    await tester.pumpWidget(widget);
    await tester.tap(find.text('Try URI'));
    await tester.pump(Duration(milliseconds: 100));
    //expect(find.text('error loading URI'), findsOneWidget);
  });
}
