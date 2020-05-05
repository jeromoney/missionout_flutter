import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/Provider/team.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/CreateScreen/create_screen.dart';
import 'package:missionout/UI/DetailScreen/detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../Mock/team_fake.dart';
import '../Mock/user_fake.dart';

void main() {
  group('SubmitMissionButton widget tests', () {
    testWidgets('Error in form', (WidgetTester tester) async {
      Widget widget = MaterialApp(
        home: Scaffold(
          body: Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (_) {
                    return 'some error';
                  },
                ),
                SubmitMissionButton(
                  mission: null,
                  actionController: TextEditingController(),
                  longitudeController: TextEditingController(),
                  latitudeController: TextEditingController(),
                  descriptionController: TextEditingController(),
                  locationController: TextEditingController(),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.tap(find.byType(SubmitMissionButton));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('Sucessful form but error in upload',
        (WidgetTester tester) async {
      Widget widget = MultiProvider(
          providers: <SingleChildWidget>[
            Provider<Team>(
                create: (_) => TeamFake(yieldValue: Yield.error)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (_) {
                        return;
                      },
                    ),
                    SubmitMissionButton(
                      mission: null,
                      actionController: TextEditingController(),
                      longitudeController: TextEditingController(),
                      latitudeController: TextEditingController(),
                      descriptionController: TextEditingController(),
                      locationController: TextEditingController(),
                    ),
                  ],
                ),
              ),
            ),
          ));
      await tester.pumpWidget(widget);
      await tester.tap(find.byType(SubmitMissionButton));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Sucessful form and sucessful upload',
        (WidgetTester tester) async {
      Widget widget = MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<User>(create: (_) => UserFake()),
            Provider<Team>(
                create: (_) => TeamFake(yieldValue: Yield.results)),
            Provider<Team>(
                create: (_) => TeamFake()),

          ],
          child: MaterialApp(
            routes: {
              '/detail': (context) => DetailScreen(),
            },
            home: Scaffold(
              body: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (_) {
                        return;
                      },
                    ),
                    SubmitMissionButton(
                      mission: null,
                      actionController: TextEditingController(),
                      longitudeController: TextEditingController(),
                      latitudeController: TextEditingController(),
                      descriptionController: TextEditingController(),
                      locationController: TextEditingController(),
                    ),
                  ],
                ),
              ),
            ),
          ));
      await tester.pumpWidget(widget);
      await tester.tap(find.byType(SubmitMissionButton));
      await tester.pumpAndSettle();
      expect(find.byType(DetailScreen), findsOneWidget);
    });

    testWidgets('Sucessful form and sucessful upload',
        (WidgetTester tester) async {
      Widget widget = MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<User>(create: (_) => UserFake()),
            Provider<Team>(
                create: (_) => TeamFake(yieldValue: Yield.results)),
            Provider<Team>(
                create: (_) => TeamFake()),
          ],
          child: MaterialApp(
            routes: {
              '/detail': (context) => DetailScreen(),
            },
            home: Scaffold(
              body: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (_) {
                        return;
                      },
                    ),
                    SubmitMissionButton(
                      mission: null,
                      actionController: TextEditingController(),
                      longitudeController: TextEditingController(),
                      latitudeController: TextEditingController(),
                      descriptionController: TextEditingController(),
                      locationController: TextEditingController(),
                    ),
                  ],
                ),
              ),
            ),
          ));
      await tester.pumpWidget(widget);
      await tester.tap(find.byType(SubmitMissionButton));
      await tester.pumpAndSettle();
      expect(find.byType(DetailScreen), findsOneWidget);
    });
  });

  group('fetchMission unit tests', () {
    test('Creates a geopoint', () {
      final someController = TextEditingController();
      final latController = TextEditingController();
      final lonController = TextEditingController();
      latController.text = '12.0';
      lonController.text = '14.0';

      SubmitMissionButton widget = SubmitMissionButton(
        mission: null,
        locationController: someController,
        descriptionController: someController,
        latitudeController: latController,
        longitudeController: lonController,
        actionController: someController,
      );
      Mission mission = widget.fetchMission();
      assert(mission.location == GeoPoint(12.0,14.0));
    });

    test('Update existing mission', () {
      final locationController = TextEditingController();
      locationController.text = 'new location';
      final descriptionController = TextEditingController();
      descriptionController.text = 'new description';
      final actionController = TextEditingController();
      actionController.text = 'new action';
      final latController = TextEditingController();
      final lonController = TextEditingController();
      latController.text = '12.0';
      lonController.text = '14.0';

      SubmitMissionButton widget = SubmitMissionButton(
        mission: Mission('some','thing','location',null),
        locationController: locationController,
        descriptionController: descriptionController,
        latitudeController: latController,
        longitudeController: lonController,
        actionController: actionController,
      );
      Mission mission = widget.fetchMission();
      assert (mission.description =='new description');
    });
  });
}
