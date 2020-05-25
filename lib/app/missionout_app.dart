import 'package:flutter/material.dart';
import 'package:missionout/app/detail_screen/detail_screen.dart';
import 'package:missionout/app/editor_screen/editor_screen.dart';
import 'package:missionout/app/overview_screen.dart';
import 'package:missionout/app/user_screen/user_screen.dart';
import 'package:missionout/core/fcm_message_handler.dart';

/// A sub-MaterialApp that is created once all of the providers have been
/// set up.
class MissionOutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FCMMessageHandler(
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => OverviewScreen(),
          EditorScreen.routeName: (context) => EditorScreen(),
          UserScreen.routeName: (context) => UserScreen(),
          DetailScreen.routeName: (context) => DetailScreen(),
        },
      ),
    );
  }
}
