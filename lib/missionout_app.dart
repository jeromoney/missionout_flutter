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
