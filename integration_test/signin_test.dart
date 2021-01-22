import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:missionout/app/create_screen/create_screen.dart';
import 'package:missionout/app/detail_screen/detail_screen.dart';
import 'package:missionout/core/platforms.dart';
import 'package:missionout/main.dart';
import 'package:tuple/tuple.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("Starting app goes to welcome screen", (WidgetTester tester) async {
    final Tuple2 tuple = await appSetup();
    await tester.pumpWidget(MyApp(
      appleSignInAvailable: tuple.item1,
      notificationAppLaunchDetails: tuple.item2,
    ));
    expect(find.byKey(Key("Welcome Logo")), findsOneWidget);
  });

  testWidgets("Starting app in demo mode goes to overview screen", (WidgetTester tester) async {
    final Tuple2 tuple = await appSetup();
    await tester.pumpWidget(MyApp(
      appleSignInAvailable: tuple.item1,
      notificationAppLaunchDetails: tuple.item2,
      runInDemoMode: true,
    ));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("Welcome Logo")), findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 15));
    expect(find.byKey(Key("Welcome Logo")), findsNothing);
    expect(find.byKey(Key("Overview Screen")), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // create a mission and submit
    expect(find.byType(CreateScreen), findsOneWidget);

    await tester.enterText(find.byKey(Key("Description")), "A sample test mission");
    await tester.enterText(find.byKey(Key("Need for action")), "A sample test need for action");
    await tester.tap(find.byType(SubmitMissionButton));
    await tester.pumpAndSettle();

    expect(find.byType(DetailScreen), findsOneWidget);
    expect(find.text("A sample test mission"), findsOneWidget);

  });
}
