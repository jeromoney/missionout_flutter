import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/BLoC/bloc_provider.dart';
import 'package:missionout/BLoC/missions_bloc.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/UI/create_screen.dart';
import 'package:missionout/UI/detail_screen.dart';
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
          // store mission as mission of focus in Bloc
          missionsBloc.detailMission = mission;
          return ListTile(
            title: Text(mission.description ?? ''),
            subtitle: Text(mission.needForAction ?? ''),
            onTap: () => {Navigator.of(context).pushNamed('/detail')},
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: missions.length);
  }
}

class CreatePopupRoute extends PopupRoute{
  // A popup route is used so back navigation doesn't go back to this screen.

  @override
  Color get barrierColor => Colors.red;

  @override
  bool get barrierDismissible => false;
  @override
  String get barrierLabel => "Close";

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
      return CreateScreen();
  }
}
