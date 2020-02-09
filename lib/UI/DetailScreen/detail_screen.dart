import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/Provider/firestore_service.dart';
import 'package:missionout/UI/DetailScreen/Sections/actions_detail_screen.dart';
import 'package:missionout/UI/DetailScreen/Sections/edit_detail_screen.dart';
import 'package:missionout/UI/DetailScreen/Sections/info_detail_screen.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Remove route if accessed from create screen
    return Scaffold(
        appBar: MyAppBar(title: 'Mission Detail',),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DetailScreenStreamWrapper(detailItem: InfoDetailScreen,),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                DetailScreenStreamWrapper(detailItem: ActionsDetailScreen),
                EditDetailScreen(),
              ],
            ),
          ),
        ));
  }
}

// Stream wrapper for the individual components. Helps separate code for testing
class DetailScreenStreamWrapper extends StatelessWidget {
  final Type detailItem;

  DetailScreenStreamWrapper({Key key, @required this.detailItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final extendedUser = Provider.of<ExtendedUser>(context);
    final db = Provider.of<FirestoreService>(context);

    return StreamBuilder<Mission>(
        stream: db.fetchSingleMission(
          teamID: extendedUser.teamID,
          docID: extendedUser.missionID,
        ),
        builder: (context, snapshot) {
          switch (detailItem) {
            case InfoDetailScreen:
              {
                return InfoDetailScreen(snapshot: snapshot,);
              }
            case ActionsDetailScreen:
              {
                return ActionsDetailScreen(snapshot: snapshot);
              }

            default:
              {
                // Should never get here
                throw DiagnosticLevel.error;
              }
              break;
          }
        });
  }
}