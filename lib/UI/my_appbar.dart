import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:missionout/BLoC/bloc_provider.dart';
import 'package:missionout/BLoC/user_bloc.dart';

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
              final alert = AlertDialog(
                  title: Text('Sign out?'),
                  content: Text('You will no longer receive pages.'),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('Sign out'),
                        onPressed: () {
                          BlocProvider.of<UserBloc>(context).handleSignOut();
                          Navigator.pop(context);
                        }),
                  ]);

              showDialog(
                context: context,
                builder: (context) => alert,
              );
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Sign out'),
              ),
            ],
          )
        ]);
}
