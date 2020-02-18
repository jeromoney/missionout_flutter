import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:missionout/Provider/team.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/CreateScreen/create_screen.dart';
import 'package:provider/provider.dart';

class EditDetailScreen extends StatelessWidget {
  final AsyncSnapshot snapshot;

  const EditDetailScreen({Key key, @required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final team = Provider.of<Team>(context);
    // waiting
    if (snapshot.connectionState == ConnectionState.waiting) {
      return LinearProgressIndicator();
    }
    // error
    if (snapshot.data == null) {
      return Text("There was an error.");
    }
    // success
    final Mission mission = snapshot.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // TODO - think there is a way to do this with one call, syntactic sugar
        user.isEditor
            ? Divider(
                thickness: 1,
              )
            : SizedBox.shrink(),
        user.isEditor
            ? ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('Page Team'),
                    onPressed: () {
                      final page = Page(
                          mission: mission);
                      team.addPage(
                          page: page);
                    },
                  ),
                  FlatButton(
                    child: const Text('Edit'),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement(CreatePopupRoute(mission));
                    },
                  ),
                  FlatButton(
                    child: Text(
                        mission.isStoodDown ? '(un)Standown' : 'Stand down'),
                    onPressed: () {
                      mission.isStoodDown = !mission.isStoodDown;
                      team.standDownMission(
                        mission: mission,
                      );
                    },
                  ),
                ],
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
