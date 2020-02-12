import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/mission_address.dart';
import 'package:missionout/Provider/database.dart';
import 'package:missionout/Provider/firestore_database.dart';
import 'package:missionout/Provider/user_firebase.dart';
import 'package:missionout/UI/CreateScreen/create_screen.dart';
import 'package:missionout/UI/DetailScreen/detail_screen.dart';
import 'package:missionout/UI/main_screen.dart';
import 'package:provider/provider.dart';

import 'Provider/user.dart';

const bool USE_FAKE_DATABASE = false;

void main() => runApp(MissionOut());

class MissionOut extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (_) => MyFirebaseUser(),),
        Provider<Database>(create: (_) => FirestoreDatabase(),),
        Provider<MissionAddress>(create: (_) => MissionAddress(),)
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
