import 'package:flutter/material.dart';
import 'package:mission_out/BLoC/bloc_provider.dart';
import 'package:mission_out/BLoC/missions_bloc.dart';
import 'package:mission_out/DataLayer/mission.dart';
import 'package:mission_out/UI/create_screen.dart';
import 'package:mission_out/UI/detail_screen.dart';

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
                            'need snowmobile team', 'cottonwood pass'),
                      )))
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: missions.length);
  }
}
