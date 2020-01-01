
import 'package:flutter/material.dart';
import 'package:missionout/BLoC/bloc_provider.dart';
import 'package:missionout/BLoC/user_bloc.dart';

class MyAppBar extends AppBar {

  MyAppBar({Key key, Widget title, String photoURL})
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
            onSelected: (int result) => print(result),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Working a lot harder'),
              ),
            ],
          )
        ]);
}
