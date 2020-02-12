import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/UI/CreateScreen/Sections/gps_text_form_field.dart';

void main() {
  group('GPSTextFormField widget tests', (){
    testWidgets('GPSTextFormField widget smoke test',
            (WidgetTester tester) async {
          Widget widget = MaterialApp(
              home: Scaffold(
                  body: GPSTextFormField(
                    controller: null,
                    companionController: null,
                    gpsType: GPS.longitude,
                  )));
          await tester.pumpWidget(widget);
        });
    testWidgets('GPSTextFormField widget test out of range value',
            (WidgetTester tester) async {
          final controller = TextEditingController();
          Widget widget = MaterialApp(
              home: Scaffold(
                  body: GPSTextFormField(
                    controller: controller,
                    companionController: null,
                    gpsType: GPS.longitude,
                  )));
          await tester.pumpWidget(widget);
          var finder = find.byType(TextFormField);
          await tester.enterText(finder, '45566');
          await tester.pumpAndSettle();
        });
  });

  group('LatLonValidator unit tests', (){
    test('LatLonValidator sucessful tests', (){
      assert (LatLonValidator(GPS.longitude, '23', TextEditingController()) == null);
      assert (LatLonValidator(GPS.longitude, '-180', TextEditingController()) == null);
      assert (LatLonValidator(GPS.longitude, '180', TextEditingController()) == null);
      assert (LatLonValidator(GPS.latitude, '5', TextEditingController()) == null);
      assert (LatLonValidator(GPS.latitude, '-90', TextEditingController()) == null);
      assert (LatLonValidator(GPS.latitude, '90', TextEditingController()) == null);
      assert (LatLonValidator(GPS.latitude, '', TextEditingController()) == null); // Allows blanks if both screens are empty

    });
    test('LatLonValidator unsucessful tests', (){
      assert (LatLonValidator(GPS.longitude, '999', TextEditingController()) == 'Enter a valid Lon');
      assert (LatLonValidator(GPS.longitude, '-181', TextEditingController()) == 'Enter a valid Lon');
      assert (LatLonValidator(GPS.longitude, '181', TextEditingController()) == 'Enter a valid Lon');
      assert (LatLonValidator(GPS.latitude, '544', TextEditingController()) == 'Enter a valid Lat');
      assert (LatLonValidator(GPS.latitude, '-91', TextEditingController()) == 'Enter a valid Lat');
      assert (LatLonValidator(GPS.latitude, '91', TextEditingController()) == 'Enter a valid Lat');
    });
  });

}
