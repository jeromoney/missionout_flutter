import 'package:flutter/material.dart';
import 'package:missionout/UI/overview_screen.dart';

class SignedinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('dick butt'),
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [];
              },
            )
          ],
        ),
        body: OverviewScreen());
  }
}
