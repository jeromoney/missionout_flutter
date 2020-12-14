import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/Provider/AuthService/auth_service.dart';
import 'package:missionout/Provider/Team/team.dart';
import 'package:missionout/Provider/User/user.dart';
import 'package:missionout/UI/EditorScreen/editor_screen.dart';
import 'package:provider/provider.dart';

import '../Mock/auth_service_fake.dart';
import '../Mock/providers_fake.dart';
import '../Mock/team_fake.dart';
import '../Mock/user_fake.dart';

void main() {
  testWidgets('TeamSubmitRaisedButton widget smoke test',
          (WidgetTester tester) async {
        Widget widget = MultiProvider(
            providers: PROVIDERS_FAKE,
            child: MaterialApp(home: Scaffold(body: EditorScreen())),
        );
        await tester.pumpWidget(widget);
        expect(find.text('Submit'
        )
        ,
        findsOneWidget
        );
      });
  testWidgets('TeamSubmitRaisedButton widget submit data with erroneous field',
          (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        Widget widget = MultiProvider(
          providers: PROVIDERS_FAKE,
          child: MaterialApp(
              home: Scaffold(
                  body: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              child: TeamSubmitRaisedButton(
                                formKey: formKey,
                                chatURIController: TextEditingController(),
                                lonController: TextEditingController(),
                                latController: TextEditingController(),
                              )),
                          TextFormField(
                            validator: (value) => 'some error',
                          )
                        ],
                      )))),
        );
        await tester.pumpWidget(widget);
        expect(find.text('Submit'), findsOneWidget);
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();
        expect(find.byType(SnackBar), findsNothing);
      });

  testWidgets('TeamSubmitRaisedButton widget submit data with correct field',
          (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        Widget widget = MultiProvider(
          providers: PROVIDERS_FAKE,
          child: MaterialApp(
              home: Scaffold(
                  body: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              child: TeamSubmitRaisedButton(
                                formKey: formKey,
                                chatURIController: TextEditingController(),
                                lonController: TextEditingController(),
                                latController: TextEditingController(),
                              )),
                          TextFormField(
                            validator: (value) => null,
                          )
                        ],
                      )))),
        );
        await tester.pumpWidget(widget);
        expect(find.text('Submit'), findsOneWidget);
        await tester.tap(find.text('Submit'));
        await tester.pump();
        expect(find.byIcon(Icons.check), findsOneWidget);
      });

  testWidgets('TeamSubmitRaisedButton widget submit data with geo data',
          (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();
        final latController = TextEditingController();
        latController.text = '3.33';
        final lonController = TextEditingController();
        lonController.text = '12.33';

        Widget widget = MultiProvider(
          providers: PROVIDERS_FAKE,
          child: MaterialApp(
              home: Scaffold(
                  body: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              child: TeamSubmitRaisedButton(
                                formKey: formKey,
                                chatURIController: TextEditingController(),
                                lonController: lonController,
                                latController: latController,
                              )),
                          TextFormField(
                            validator: (value) => null,
                          )
                        ],
                      )))),
        );
        await tester.pumpWidget(widget);
        expect(find.text('Submit'), findsOneWidget);
        await tester.tap(find.text('Submit'));
        await tester.pump();
        expect(find.byIcon(Icons.check), findsOneWidget);
      });

  testWidgets('TeamSubmitRaisedButton widget submit data that causes error',
          (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();
        final latController = TextEditingController();
        latController.text = '3.33';
        final lonController = TextEditingController();
        lonController.text = '12.33';

        Widget widget = MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>(
              create: (_) => AuthServiceFake(),),
            ChangeNotifierProvider<User>(
              create: (_) => UserFake(),
            ),
            Provider<Team>(
              create: (_) => TeamFake(yieldValue: Yield.error),
            ),
          ],
          child: MaterialApp(
              home: Scaffold(
                  body: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              child: TeamSubmitRaisedButton(
                                formKey: formKey,
                                chatURIController: TextEditingController(),
                                lonController: lonController,
                                latController: latController,
                              )),
                          TextFormField(
                            validator: (value) => null,
                          )
                        ],
                      )))),
        );
        await tester.pumpWidget(widget);
        expect(find.text('Submit'), findsOneWidget);
        await tester.tap(find.text('Submit'));
        await tester.pump();
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });
}
