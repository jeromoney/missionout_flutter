import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/BLoC/bloc_provider.dart';
import 'package:missionout/BLoC/missions_bloc.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/UI/create_screen.dart';
import 'package:missionout/BLoC/user_bloc.dart';
import 'package:missionout/UI/my_appbar.dart';

class OverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);
    final missionsBloc = BlocProvider.of<MissionsBloc>(context);
    final user = userBloc.user;
    assert(user != null);
    return Scaffold(
        appBar: MyAppBar(
          title: Text('Missions Overview'),
          photoURL: user.photoUrl,
          context: context,
        ),
        body: _buildResults(missionsBloc),
        floatingActionButton: userBloc.isEditor // only show FAB to editors
            ? FloatingActionButton(
                child: Icon(Icons.create),
                onPressed: () {
                  Navigator.of(context).push(CreatePopupRoute());
                })
            : null);
  }

  Widget _buildResults(MissionsBloc bloc) {
    return StreamBuilder<QuerySnapshot>(
        stream: bloc.missionsStream,
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
          final documents = snapshot.data.documents;
          final missions =
              documents.map((data) => Mission.fromSnapshot(data)).toList();
          // removing missions with incomplete fields. This is a little crude
          missions.removeWhere((mission) => mission == null);

          if (documents.length == 0) {
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
          final missionsBloc = BlocProvider.of<MissionsBloc>(context);

          return ListTile(
            title: Text(mission.description ?? ''),
            subtitle: Text(mission.needForAction ?? ''),
            onTap: () {
              missionsBloc.detailMission = mission;
              Navigator.of(context).pushNamed('/detail');
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: missions.length);
  }
}
