import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/user_client.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget  {
  String _title;

  MyAppBar({@required String title}) {
    _title = title;
  }

  static Future<void> _printUserToken(FirebaseUser user) async {
    var token = await user.getIdToken();
    debugPrint(token.token);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return AppBar(title: Text(_title), actions: <Widget>[
      Container(
          width: AppBar().preferredSize.height,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(user.photoUrl),
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
                final user = Provider.of<FirebaseUser>(context);
                _printUserToken(user);
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
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
