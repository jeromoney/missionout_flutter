import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/user_client.dart';
import 'package:missionout/UI/editor_screen.dart';
import 'package:missionout/UI/UserScreen/user_screen.dart';
import 'package:provider/provider.dart';

enum Menu { signOut, userOptions, editorOptions, printToken }

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
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
                image: CachedNetworkImageProvider(user.photoUrl),
              ))),
      PopupMenuButton<Menu>(
        onSelected: (Menu result) {
          switch (result) {
            case Menu.signOut:
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

            case Menu.userOptions:
              {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => UserScreen()));
              }
              break;

            case Menu.editorOptions:
              {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => EditorScreen()));
              }
              break;

            case Menu.printToken:
              {
                final user = Provider.of<FirebaseUser>(context, listen: false);
                _printUserToken(user);
              }
          }
        },
        itemBuilder: (BuildContext context) => const <PopupMenuEntry<Menu>>[
          PopupMenuItem<Menu>(
            value: Menu.signOut,
            child: Text('Sign out'),
          ),
          PopupMenuItem<Menu>(
            value: Menu.userOptions,
            child: Text('User Options'),
          ),
          PopupMenuItem<Menu>(
            value: Menu.editorOptions,
            child: Text('Editor Options'),
          ),
          PopupMenuItem<Menu>(
            value: Menu.printToken,
            child: Text('Print token'),
          ),
        ],
      )
    ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
