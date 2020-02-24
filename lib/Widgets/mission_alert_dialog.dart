
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/mission_address.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:provider/provider.dart';


class MissionAlertDialog extends StatelessWidget {
  final Map<String, dynamic> message;

  const MissionAlertDialog({Key key, @required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = Page.fromMap(
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
                    .of<MissionAddress>(context, listen: false)
                    .address =
                Map.castFrom<dynamic, dynamic, String, dynamic>(
                    message['data'])['address'];
                Navigator.of(context).pushReplacementNamed('/detail');
              }),
        ]);
  }
}
