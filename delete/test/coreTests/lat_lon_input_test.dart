import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/core/lat_lon_input.w.dart';

void main() {
  group('LatLon unit tests', () {
    test('latValidator unit tests', () {
      final controller = TextEditingController();
      controller.text = '';
      expect(latValidator('', controller), null);
      expect(latValidator('dghk', null), 'Enter a valid number');
      expect(latValidator('-90.1', null), 'Lat is between -90 and 90');
      expect(latValidator('90.1', null), 'Lat is between -90 and 90');
      expect(latValidator('89', null), null);
    });

    test('lonValidator unit tests', () {
      final controller = TextEditingController();
      controller.text = '';
      expect(lonValidator('', controller), null);
      expect(lonValidator('dghk', null), 'Enter a valid number');
      expect(lonValidator('-180.1', null), 'Lon is between -180 and 180');
      expect(lonValidator('180.1', null), 'Lon is between -180 and 180');
      expect(lonValidator('89', null), null);
    });
  });

  group('LatLonInput widget tests', () {
    testWidgets('LatLonInput widget test validation',
        (WidgetTester tester) async {
      final _formKey = GlobalKey<FormState>();
      Widget widget = MaterialApp(
        home: Scaffold(
          body: Form(
              key: _formKey,
              child: LatLonInput(
                fieldDescription: 'Some description',
                latController: TextEditingController(),
                lonController: TextEditingController(),
              )),
        ),
      );
      await tester.pumpWidget(widget);
      expect(find.text('Some description'), findsOneWidget);
      expect(_formKey.currentState.validate(), true);
      await tester.enterText(find.byType(TextFormField).first, '33');
      expect(_formKey.currentState.validate(), false);
      await tester.enterText(find.byType(TextFormField).last, '106');
      expect(_formKey.currentState.validate(), true);
      await tester.enterText(find.byType(TextFormField).last, 'abds');
      expect(_formKey.currentState.validate(), false);

        });
  });
}
