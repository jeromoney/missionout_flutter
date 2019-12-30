import 'package:flutter/material.dart';
import 'package:missionout/BLoC/bloc_provider.dart';
import 'package:missionout/BLoC/missions_bloc.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/UI/create_screen.dart';
import 'package:missionout/UI/detail_screen.dart';

class OverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = MissionsBloc();
    bloc.getMissions();

    return BlocProvider<MissionsBloc>(
        bloc: bloc,
        child: Scaffold(
            body: _buildResults(bloc),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.create),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => CreateScreen()));
                })));
  }

  Widget _buildResults(MissionsBloc bloc) {
    return StreamBuilder<List<Mission>>(
        stream: bloc.missionsStream,
        builder: (context, snapshot) {
          final missions = snapshot.data;

          if (missions == null) {
            return Center(
              child: Text('There was an error.'),
            );
          }
          if (missions.isEmpty) {
            return Center(
              child: Text('No recent results.'),
            );
          }
          return _buildMissionResults(missions);
        });
  }

  Widget _buildMissionResults(List<Mission> missions) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          final mission = missions[index];
          return ListTile(
            title: Text(mission.description),
            subtitle: Text(mission.needForAction),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => DetailScreen(
                        mission: Mission('Lost snowmobilers',
                            'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'cottonwood pass'),
                      )))
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: missions.length);
  }
}
