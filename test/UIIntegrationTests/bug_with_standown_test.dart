/*
In the DetailScreen, nothing happens when an editor clicks on the standdown button
Step 1) Observed that the boolean field in the database changes so it is probably a UI error
Step 2) Observed boolean in UI widget. Firestore is passing the new data, but somehow the value gets
corrupted. Check the data object
Step 3) The firestore_team was writing to the old key of 'stoodDown' when it should have been 'isStoodDown'
 */

import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'When editor clicks on standdown button in Detail Screen, the mission should be stooddown',
      (WidgetTester tester) async {
        // no tests for now
      });
}
