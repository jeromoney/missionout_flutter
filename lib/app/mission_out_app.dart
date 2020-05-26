import 'package:flutter/material.dart';
import 'package:missionout/app/detail_screen/detail_screen.dart';
import 'package:missionout/app/editor_screen/editor_screen.dart';
import 'package:missionout/app/overview_screen.dart';
import 'package:missionout/app/response_screen.dart';
import 'package:missionout/app/user_screen/user_screen.dart';
import 'package:missionout/main.dart';

class MissionOutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: MyApp.navKey,
        title: 'Mission Out',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        darkTheme: ThemeData.dark(),
        initialRoute: OverviewScreen.routeName,
        routes: {
          OverviewScreen.routeName: (context) => OverviewScreen(),
          EditorScreen.routeName: (context) => EditorScreen(),
          UserScreen.routeName: (context) => UserScreen(),
          DetailScreen.routeName: (context) => DetailScreen(),
          ResponseScreen.routeName: (context) => ResponseScreen(),
        },
      );
}
