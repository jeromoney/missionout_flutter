import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:missionout/app/create_screen/create_screen.dart';
import 'package:missionout/app/detail_screen/detail_screen.dart';
import 'package:missionout/core/platforms.dart';
import 'package:missionout/main.dart';
import 'package:missionout/services/apple_sign_in_available.dart';
import 'package:tuple/tuple.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("Starting app goes to welcome screen",
      (WidgetTester tester) async {
    final Tuple2<AppleSignInAvailable, NotificationAppLaunchDetails> tuple =
        await appSetup();
    await tester.pumpWidget(MyApp(
      appleSignInAvailable: tuple.item1,
      notificationAppLaunchDetails: tuple.item2,
    ));
    expect(find.byKey(const Key("Welcome Logo")), findsOneWidget);
  });

  testWidgets("Starting app in demo mode goes to overview screen",
      (WidgetTester tester) async {
    final Tuple2<AppleSignInAvailable, NotificationAppLaunchDetails> tuple =
        await appSetup();
    await tester.pumpWidget(MyApp(
      appleSignInAvailable: tuple.item1,
      notificationAppLaunchDetails: tuple.item2,
      runInDemoMode: true,
    ));
    await tester.pumpAndSettle(const Duration(seconds: 15));
    expect(find.byKey(const Key("Welcome Logo")), findsNothing);
    expect(find.byKey(const Key("Overview Screen")), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // create a mission and submit
    expect(find.byType(CreateScreen), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key("Description")), "A sample test mission");
    await tester.enterText(find.byKey(const Key("Need for action")),
        "A sample test need for action");
    await tester.tap(find.byType(SubmitMissionButton));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(DetailScreen), findsOneWidget);
    expect(find.text("A sample test mission"), findsOneWidget);
  });

  testWidgets("Sign in and then sign out", (WidgetTester tester) async {
    final Tuple2<AppleSignInAvailable, NotificationAppLaunchDetails> tuple =
        await appSetup();
    await tester.pumpWidget(MyApp(
      appleSignInAvailable: tuple.item1,
      notificationAppLaunchDetails: tuple.item2,
      runInDemoMode: true,
    ));
    await tester.pumpAndSettle(const Duration(seconds: 15));
    expect(find.byKey(const Key("Welcome Logo")), findsNothing);
    expect(find.byKey(const Key("Overview Screen")), findsOneWidget);

    await tester.tap(find.byKey(const Key('PopupMenuButton')));
    await tester.pumpAndSettle();
    expect(find.text("Sign out"), findsOneWidget);

    await tester.tap(find.text("Sign out"));
    await tester.pumpAndSettle();

    expect(find.text("Ok"), findsOneWidget);
    await tester.tap(find.text("Ok"));
    await tester.pumpAndSettle(const Duration(seconds: 30));

   expect(find.text("Read our privacy policy"), findsOneWidget);
  });
}
