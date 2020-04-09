import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/mission_address.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/Provider/team.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/CreateScreen/create_screen.dart';
import 'package:missionout/UI/DetailScreen/detail_screen.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:missionout/utils.dart';
import 'package:provider/provider.dart';

class OverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
        appBar: MyAppBar(title: 'Missions Overview'),
        body: BuildMissionStream(),
        floatingActionButton: user.isEditor // only show FAB to editors
            ? FloatingActionButton(
                child: Icon(Icons.create),
                onPressed: () {
                  Navigator.of(context).push(CreatePopupRoute());
                })
            : null);
  }
}

@visibleForTesting
class BuildMissionStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final team = Provider.of<Team>(context);
    return StreamBuilder<List<Mission>>(
        stream: team.fetchMissions(),
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

@visibleForTesting
class BuildMissionResults extends StatelessWidget {
  final List<Mission> missions;

  const BuildMissionResults({Key key, @required this.missions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          final mission = missions[index];

          return ListTile(
            title: Text(mission.description ?? '',
                style: mission.isStoodDown ?? false
                    ? TextStyle(decoration: TextDecoration.lineThrough)
                    : Theme.of(context).textTheme.body1),
            subtitle: Text((mission.needForAction ?? '') +
                ' ' +
                (formatTime(mission.time) ?? '')),
            onTap: () {
              Provider.of<MissionAddress>(context, listen: false).address =
                  mission.address;
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen()));
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: missions.length);
  }
}
