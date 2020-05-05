
import 'package:flutter/material.dart';
import 'package:missionout/Provider/user.dart';
import 'package:provider/provider.dart';


import 'package:missionout/DataLayer/page.dart' as missionpage;
import 'package:missionout/UI/DetailScreen/detail_screen.dart';


class MissionAlertDialog extends StatelessWidget {
  final Map<String, dynamic> message;

  const MissionAlertDialog({Key key, @required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = missionpage.Page.fromMap(
        Map.castFrom<dynamic, dynamic, String, dynamic>(message['data']));
    return AlertDialog(
        title: Text(page.description),
        content: Text(page.needForAction),
        actions: <Widget>[
          FlatButton(
              child: Text('Details'),
              onPressed: () {
                Navigator.pop(context);
                Provider
                    .of<User>(context, listen: false)
                    .currentMission =
                Map.castFrom<dynamic, dynamic, String, dynamic>(
                    message['data'])['address'];
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailScreen()));
              }),
        ]);
  }
}
