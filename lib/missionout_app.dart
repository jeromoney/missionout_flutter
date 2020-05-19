import 'package:flutter/material.dart';
import 'package:missionout/Provider/Team/demo_team.dart';
import 'package:missionout/Provider/Team/team.dart';
import 'package:missionout/core/fcm_message_handler.dart';
import 'package:provider/provider.dart';
import 'UI/EditorScreen/editor_screen.dart';
import 'UI/UserScreen/user_screen.dart';
import 'UI/overview_screen.dart';

class MissionOutApp extends StatefulWidget {
  @override
  State<MissionOutApp> createState() => _MissionOutAppState();
}

class _MissionOutAppState extends State<MissionOutApp> {
  bool _dialogFlag = false;

  @override
  Widget build(BuildContext context) {
    final team = Provider.of<Team>(context);
    if (team == null || !team.isInitialized)
      return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        darkTheme: ThemeData.dark(),
        home: Center(
          child: CircularProgressIndicator(),
        ),
      );

    // Alert users that can't be identified that they are in sandbox mode
    // make sure they are only shown it once
    if (!_dialogFlag) {
      _dialogFlag = true;
      if (!["chaffeecountysarnorth.org"].contains(team.teamID)) { // TODO - make this not hard coded
        String message;
        if (team.runtimeType == DemoTeam) {
          message =
              "This demo account demonstrates the basic features of the app. You will not receive any pages.";
        } else {
          message =
              "Could not locate a team with domain ${team.teamID}. Sign out and sign back in with your team email or contact your adminstrator for help";
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertDialog dialog = AlertDialog(
            content: Text(message),
          );
          showDialog(context: context, child: dialog);
        });
      }
    }

    return FCMMessageHandler(
      child: MaterialApp(
        title: 'Mission Out',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        darkTheme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (context) => OverviewScreen(),
          '/editor_options': (context) => EditorScreen(),
          '/user_options': (context) => UserScreen()
        },
      ),
    );
  }
}
