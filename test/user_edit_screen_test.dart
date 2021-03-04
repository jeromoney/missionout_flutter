import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/app/user_edit_screen/user_edit_screen.dart';

import 'test_providers.dart';

void main() {
  group('User Edit Screen Tests ', () {
    testWidgets('User Edit Screen Smoke Test', (WidgetTester tester) async {
      await tester.pumpWidget(getWidgetWithProviders(UserEditScreen()));
      expect(find.text("Joe Blow"), findsOneWidget);
    });

    testWidgets('User Edit Screen Test - Change display name',
        (WidgetTester tester) async {
      await tester.pumpWidget(getWidgetWithProviders(UserEditScreen()));
      await tester.enterText(find.text("Joe Blow"), "Joe Exotic");
      expect(find.text("Joe Exotic"), findsOneWidget);
    });
  });

  group("Phone Edit Screen breakout tests", (){
    testWidgets('User Edit Screen Test --  - Change display name',
            (WidgetTester tester) async {
          await tester.pumpWidget(getWidgetWithProviders(UserEditScreen()));
          await tester.enterText(find.text("Joe Blow"), "Joe Exotic");
          expect(find.text("Joe Exotic"), findsOneWidget);
        });
  });
}
