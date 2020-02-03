import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessageHandler extends StatefulWidget {
  @override
  State createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final _fcm = FirebaseMessaging();

  @override
  void initState() {
    _fcm.configure(
      // App is running in foreground
      onMessage: (Map<String, dynamic> message) async {
        debugPrint('onMessage: $message');
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: ListTile(
                    title: Text(message['notification']['title']),
                    subtitle: Text(message['notification']['body']),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ));
      },
      // App is closed, but running in foreground
      onResume: (Map<String, dynamic> message) async {
        debugPrint('onResume: $message');
        //TODO...
      },
      // App is terminated
      onLaunch: (Map<String, dynamic> message) async {
        debugPrint('onLaunch: $message');
        //TODO...
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
