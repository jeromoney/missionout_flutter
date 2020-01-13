import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/firestore_path.dart';
import 'package:missionout/Provider/FirestoreService.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/UI/create_screen.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:provider/provider.dart';

class OverviewScreen extends StatelessWidget {
  final db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    assert(user != null);
    return Scaffold(
        appBar: MyAppBar(
          title: Text('Missions Overview'),
          photoURL: user.photoUrl,
          context: context,
        ),
        body: _buildResults(),
        floatingActionButton: true // only show FAB to editors
            ? FloatingActionButton(
                child: Icon(Icons.create),
                onPressed: () {
                  Navigator.of(context).push(CreatePopupRoute());
                })
            : null);
  }

  Widget _buildResults() {
    return StreamBuilder<List<Mission>>(
        stream: db.fetchMissions('chaffeecountysarnorth.org'),
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

          return _buildMissionResults(missions);
        });
  }

  Widget _buildMissionResults(List<Mission> missions) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          final mission = missions[index];

          return ListTile(
            title: Text(mission.description ?? ''),
            subtitle: Text(mission.needForAction ?? ''),
            onTap: () {
              Provider.of<FirestorePath>(context, listen: false).missionID =
                  mission.reference.documentID;
              Navigator.of(context).pushNamed('/detail');
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: missions.length);
  }
}
