import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mission_out/DataLayer/mission.dart';
import 'package:mission_out/UI/create_screen.dart';

class OverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mission0 = Mission.fromJson(jsonDecode(
        '{"description": "Lost hikers on Yale", "needForAction": "need some hikers"}'));
    final mission1 = Mission.fromJson(jsonDecode(
        '{"description": "Missing snowshoers", "needForAction": "need snowmobilers"}'));

    final missions = [mission0, mission1, mission0, mission1];
    return Scaffold(
      body: _buildResults(missions),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => CreateScreen()));
        },
      ),
    );
  }

  Widget _buildResults(List<Mission> missions) {
    if (missions == null) {
      return Center(
        child: Text('There was an error.'),
      );
    }
    if (missions.isEmpty) {
      return Center(
        child: Text('No results'),
      );
    }
    return _buildMissionResults(missions);
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
                  builder: (BuildContext context) => CreateScreen()))
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: missions.length);
  }
}
