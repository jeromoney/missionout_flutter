import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/UI/create_screen.dart';
import 'package:missionout/UI/detail_screen.dart';
import 'package:missionout/UI/main_screen.dart';
import 'package:provider/provider.dart';

import 'DataLayer/firestore_path.dart';
import 'DataLayer/mission.dart';

void main() => runApp(MissionOut());

class MissionOut extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
        // Document ID String
        Provider<FirestorePath>.value(value: FirestorePath()),
      ],
      child: MaterialApp(
        title: 'Mission Out',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        darkTheme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (context) => MainScreen(),
          '/detail': (context) => DetailScreen(),
          '/create': (context) => CreateScreen(),
        },
      ),
    );
  }
}
