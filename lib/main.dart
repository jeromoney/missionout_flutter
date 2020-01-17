import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/UI/create_screen.dart';
import 'package:missionout/UI/DetailScreen/detail_screen.dart';
import 'package:missionout/UI/editor_screen.dart';
import 'package:missionout/UI/main_screen.dart';
import 'package:missionout/UI/user_screen.dart';
import 'package:missionout/widget/message_handler.dart';
import 'package:provider/provider.dart';

void main() => runApp(MissionOut());

class MissionOut extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
        Provider<ExtendedUser>.value(value: ExtendedUser()),
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
          '/userOptions': (context) => UserScreen(),
          '/editorOptions': (context) => EditorScreen(),
        },
      ),
    );
  }

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // handle message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // handle notification
      final dynamic notification = message['notification'];
    }
  }
}
