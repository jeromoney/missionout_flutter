import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Integration tests', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    test('smoke test', () async {
      // Expects that app is signed out
      final signInButtonFinder = find.byValueKey('Google Sign In Button');
      await driver.tap(signInButtonFinder);
      //await driver.tap(find.text('justin.matis@chaffeecountysarnorth.org'));


    });


    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }

    });
  });
}
