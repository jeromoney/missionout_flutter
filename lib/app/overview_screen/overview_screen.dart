import 'package:flutter/material.dart';

import 'package:missionout/app/overview_screen/overview_screen_model.dart';
import 'package:missionout/utils.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/app/my_appbar.dart';

class OverviewScreen extends StatelessWidget {
  static const routeName = "/overviewScreen";

  @override
  Widget build(BuildContext context) {
    final model = OverviewScreenModel(context: context);
    model.resetReference();
    if (model.user == null) return LinearProgressIndicator();
    return Scaffold(
        key: Key("Overview Screen"),
        appBar: MyAppBar(title: 'Overview'),
        body: BuildMissionStream(),
        floatingActionButton: model.isEditor // only show FAB to editors
            ? FloatingActionButton(
                child: Icon(Icons.create),
                onPressed: model.navigateToCreate,
              )
            : null);
  }
}

class BuildMissionStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = OverviewScreenModel(context: context);
    if (model.team == null) return LinearProgressIndicator();

    return StreamBuilder<List<Mission>>(
        stream: model.fetchMissions(),
        builder: (context, snapshot) {
          // waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator();
          }

          // error
          if (snapshot.data == null) {
            return Center(
              child: Text('There was an error.'),
            );
          }

          // successful query
          final missions = snapshot.data;
          // removing missions with incomplete fields. This is a little crude
          missions.removeWhere((mission) => mission == null);

          if (missions.length == 0) {
            return Center(
              child: Text('No recent results.'),
            );
          }

          return BuildMissionResults(
            missions: missions,
          );
        });
  }
}

class BuildMissionResults extends StatefulWidget {
  final List<Mission> missions;

  const BuildMissionResults({Key key, @required this.missions})
      : super(key: key);

  @override
  _BuildMissionResultsState createState() => _BuildMissionResultsState();
}

class _BuildMissionResultsState extends State<BuildMissionResults> {
  OverviewScreenModel model;

  @override
  Widget build(BuildContext context) {
    model = OverviewScreenModel(context: context);
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          final mission = widget.missions[index];

          return ListTile(
            title: Text(mission.description ?? '',
                style: mission.isStoodDown ?? false
                    ? TextStyle(decoration: TextDecoration.lineThrough)
                    : Theme.of(context).textTheme.body1),
            subtitle: Text((mission.needForAction ?? '') +
                ' ' +
                (formatTime(mission.time) ?? '')),
            onTap: () {
              model.navigateToDetail(documentReference: mission.selfRef);
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: widget.missions.length);
  }
}
