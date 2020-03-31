import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/EditorScreen/editor_screen.dart';
import 'package:missionout/UI/UserScreen/user_screen.dart';
import 'package:provider/provider.dart';

enum Menu { signOut, userOptions, editorOptions }

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  String _title;

  MyAppBar({@required String title}) {
    _title = title;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
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
        key: Key('PopupMenuButton'),
        // Used for testing, since I can't find this with find.byType
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
                            user.signOut();
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
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          PopupMenuItem<Menu>(
            value: Menu.userOptions,
            child: Text('User Options'),
          ),
          if (user.isEditor)
            PopupMenuItem<Menu>(
              value: Menu.editorOptions,
              child: Text('Editor Options'),
            ),
          PopupMenuItem<Menu>(
            value: Menu.signOut,
            child: Text('Sign out'),
          ),
        ],
      )
    ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
