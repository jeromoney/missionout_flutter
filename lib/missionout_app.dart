import 'package:flutter/material.dart';

import 'UI/EditorScreen/editor_screen.dart';
import 'UI/UserScreen/user_screen.dart';
import 'UI/overview_screen.dart';

class MissionOutApp extends StatelessWidget {
  // Called once all of the providers have been setup
  @override
  Widget build(BuildContext context) => MaterialApp(
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
      );
}
