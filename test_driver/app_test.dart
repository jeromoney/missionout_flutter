import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Integration tests', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    test('smoke test', () async {});


    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }

    });
  });
}
