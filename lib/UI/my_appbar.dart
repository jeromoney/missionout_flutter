import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/user_client.dart';
import 'package:missionout/Provider/bloc_provider.dart';
import 'package:missionout/Provider/user_bloc.dart';

class MyAppBar extends AppBar {
  MyAppBar({Key key, Widget title, String photoURL, BuildContext context})
      : super(key: key, title: title, actions: <Widget>[
          Container(
              width: AppBar().preferredSize.height,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(photoURL),
                  ))),
          PopupMenuButton<int>(
            onSelected: (int result) {
              switch (result) {
                case 1:
                  {
                    final alert = AlertDialog(
                        title: Text('Sign out?'),
                        content: Text('You will no longer receive pages.'),
                        actions: <Widget>[
                          FlatButton(
                              child: Text('Sign out'),
                              onPressed: () {
                                UserClient().handleSignOut();
                                Navigator.pop(context);
                                Navigator.of(context).pushReplacementNamed('/');
                              }),
                        ]);
                    showDialog(
                      context: context,
                      builder: (context) => alert,
                    );
                  }
                  break;

                case 2:
                  {
                    final userBloc = BlocProvider.of<UserBloc>(context);
                    _printUserToken(userBloc.user);

                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Sign out'),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text('Print token'),
              ),
            ],
          )
        ]);

  static Future<void> _printUserToken(FirebaseUser user) async{
    var token = await user.getIdToken();
    debugPrint(token.token);
  }
}
