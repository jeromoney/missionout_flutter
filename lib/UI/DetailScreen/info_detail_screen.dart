import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/Provider/firestore_service.dart';
import 'package:provider/provider.dart';

class InfoDetailScreen extends StatelessWidget {
  final db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final extendedUser = Provider.of<ExtendedUser>(context);
    return StreamBuilder<Mission>(
      stream: db.fetchSingleMission(
        teamID: extendedUser.teamID,
        docID: extendedUser.missionID,
      ),
      builder: (context, snapshot) {
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
            Baseline(
              baseline: 44,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                mission.description,
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            Baseline(
              baseline: 24,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                formatTime(mission.time) +
                    (mission.isStoodDown ? ' stood down' : ''),
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            Baseline(
                baseline: 32,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  mission.locationDescription,
                  style: Theme.of(context).textTheme.title,
                )),
            Baseline(
              baseline: 26,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                mission.needForAction,
                style: mission.isStoodDown
                    ? TextStyle(decoration: TextDecoration.lineThrough)
                    : Theme.of(context).textTheme.body1,
              ),
            ),
          ],
        );
      }
    );
  }
}

String formatTime(Timestamp time) {
  if (time == null) {
    return '';
  }
  final dateTime = time.toDate();
  return DateFormat('yyyy-MM-dd kk:mm').format(dateTime);
}