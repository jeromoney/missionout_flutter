import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  MyAppBar({Key key, Widget title})
      : super(key: key, title: title, actions: <Widget>[
          IconButton(onPressed: null, icon: Icon(Icons.ac_unit)),
          PopupMenuButton<int>(
            onSelected: (int result) => print(result),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Working a lot harder'),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text('Being a lot smarter'),
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: Text('Being a self-starter'),
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: Text('Placed in charge of trading charter'),
              ),
            ],
          )
        ]);
}
