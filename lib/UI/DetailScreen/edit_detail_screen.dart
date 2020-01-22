import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:missionout/Provider/firestore_service.dart';
import 'package:missionout/UI/CreateScreen/create_screen.dart';
import 'package:provider/provider.dart';

class EditDetailScreen extends StatelessWidget {
  final _db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final extendedUser = Provider.of<ExtendedUser>(context);
    return StreamBuilder(
      stream: _db.fetchSingleMission(
        teamID: extendedUser.teamID,
        docID: extendedUser.missionID,
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // waiting
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        }
        // error
        if (snapshot.data == null) {
          return Text("There was an error.");
        }
        // success
        final mission =
            snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // TODO - think there is a way to do this with one call, syntactic sugar
            extendedUser.isEditor ? Divider(thickness: 1,) : SizedBox.shrink(),
            extendedUser.isEditor
                ? ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Page Team'),
                  onPressed: () {
                    final page = Page(
                        action: mission.needForAction,
                        description: mission.description);
                    _db.addPage(
                        teamID: extendedUser.teamID,
                        missionDocID: mission.reference.documentID,
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
                  child: Text(mission.isStoodDown
                      ? '(un)Standown'
                      : 'Stand down'),
                  onPressed: () {
                    _db.standDownMission(
                        standDown: !mission.isStoodDown,
                        docID: mission.reference.documentID,
                        teamID: extendedUser.teamID);
                    //singleMissionBloc.standDownMission(standDown: !mission.isStoodDown);
                  },
                ),
              ],
            )
                : SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
