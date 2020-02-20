import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/overview_screen.dart';
import 'package:missionout/UI/signin_screen.dart';
import 'package:missionout/Widgets/mission_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:soundpool/soundpool.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        Soundpool pool = Soundpool(streamType: StreamType.notification);
        int soundID = await playSound(pool);
        showDialog(
                context: context,
                builder: (context) => MissionAlertDialog(message: message))
            .then((value) {
          // stop sound
          stopSound(pool, soundID);
        });
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
//        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
//        _navigateToItemDetail(message);
      },
    );

    final user = Provider.of<User>(context);
    if (user.isLoggedIn) {
      return OverviewScreen();
    } else {
      return SigninScreen();
    }
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}
Future<int> playSound(Soundpool pool) async {
  String soundFile;
  if (Platform.isAndroid) {
    soundFile = 'sounds/teleportSound.mp4';
  } else if (Platform.isIOS) {
    soundFile = 'sounds/teleportSound.m4a';
  }
  else {
    debugPrint('New Platform encountered: ${Platform.operatingSystem}');
  }
  int soundId = await rootBundle.load(soundFile).then((ByteData soundData) {
    return pool.load(soundData);
  });
  // return the sound id so it can be stopped
  return await pool.play(soundId, repeat: -1);
}

stopSound(Soundpool pool, int soundID) async {
  await pool.stop(soundID);
}
