import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:missionout/missionout_app.dart';
import 'package:provider/provider.dart';

import 'package:missionout/Provider/user.dart';

import 'DataLayer/app_mode.dart';

class AuthScreener extends StatefulWidget {
  var providers;

  AuthScreener({Key key, @required this.providers}) : super(key: key);

  @override
  State<AuthScreener> createState() => AuthScreenerState(providers);
}

class AuthScreenerState extends State<AuthScreener> {
  var providers;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AuthScreenerState(this.providers);

  @override
  void initState() {
    super.initState();
//    if (!Platform.isIOS){
//      // Notifications for Android are handled in MainActivity.kt
//      return;
//    }

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions(
        // Not choosing provisional for now so user either gets full notifications or none
        const IosNotificationSettings(
            sound: true, alert: true, badge: true, provisional: false));
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      //debugPrint(token);
    });
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        debugPrint("Receieved launch message");
      },
      onMessage: (Map<String, dynamic> message) async {
        debugPrint("Receieved message");
        // TODO - play an alert sound here
        AlertDialog alert = AlertDialog(
          title: Text(message["description"]),
          content: Text(message["needForAction"]),
        );
        showDialog(context: context, child: alert);
      },
      onResume: (Map<String, dynamic> message) async {
        debugPrint(message.toString());
        var iOSPlatformChannelSpecifics = IOSNotificationDetails(
            presentSound: true, sound: "school_fire_alarm.m4a");
        var platformChannelSpecifics =
            NotificationDetails(null, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(0, message["description"],
            message["needForAction"], platformChannelSpecifics,
            payload: 'item x');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Builder(
        // ignore: missing_return
        builder: (context) {
          // Don't build material app until User object reports signed in success
          final user = Provider.of<User>(context);
          switch (user.signInStatus) {
            case SignInStatus.signedOut:
              throw StateError("Error: Unexpectedly reached signed out state");
            case SignInStatus.waiting:
              return MaterialApp(
                  home: Scaffold(
                      body: Center(child: CircularProgressIndicator())));
            case SignInStatus.error:
              debugPrint("Error signing in user");
              return ResetWidget();
            case SignInStatus.signedIn:
              return MissionOutApp();
            default:
              throw StateError(
                  "Unexpected Sign In State: ${user.signInStatus}");
          }
        },
      ),
    );
  }
}

class ResetWidget extends StatefulWidget {
  // This widget adds the ability to give instructions after construction in the
  // addPostFrameCallback
  @override
  State<ResetWidget> createState() => ResetWidgetState();
}

class ResetWidgetState extends State<ResetWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appMode = Provider.of<AppMode>(context, listen: false);
      appMode.appMode = AppModes.signedOut;
    });
    super.initState();
  }
}
