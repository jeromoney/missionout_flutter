import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:missionout/DataLayer/mission.dart';

class InfoDetailScreen extends StatelessWidget {
  final AsyncSnapshot snapshot;
  const InfoDetailScreen({Key key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        Baseline(
          baseline: 44,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            mission.description,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Baseline(
          baseline: 24,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            formatTime(mission.time) +
                (mission.isStoodDown ? ' stood down' : ''),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        Baseline(
            baseline: 32,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              mission.locationDescription,
              style: Theme.of(context).textTheme.headline6
              ,
            )),
        Baseline(
          baseline: 26,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            mission.needForAction,
            style: mission.isStoodDown
                ? TextStyle(decoration: TextDecoration.lineThrough)
                : Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ],
    );
  }
}

@visibleForTesting
String formatTime(Timestamp time) {
  if (time == null) {
    return '';
  }
  final dateTime = time.toDate();
  return DateFormat('yyyy-MM-dd kk:mm').format(dateTime);
}
