import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missionout/BLoC/bloc.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/mission_client.dart';

class MissionsBloc implements Bloc {
  var _missions = <Mission>[];
  final String _teamId;

  MissionsBloc(String teamId) : this._teamId = teamId;

  List<Mission> get missions => _missions;
  final _client = MissionsClient();

  final missionsController = StreamController();

  Stream<QuerySnapshot> get missionsStream => _client.fetchMissions(_teamId);

  void addMission(Mission mission) {
    missionsController.sink.add(mission);
  }

  @override
  void dispose() {
    missionsController.close();
  }
}
