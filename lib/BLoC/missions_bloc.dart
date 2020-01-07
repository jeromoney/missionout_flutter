import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missionout/BLoC/bloc.dart';
import 'package:missionout/DataLayer/alarm.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/mission_client.dart';
import 'package:flutter/foundation.dart';
import 'package:missionout/DataLayer/response.dart';

class MissionsBloc implements Bloc {
  var _missions = <Mission>[];
  Mission detailMission;
  String teamID;

  List<Mission> get missions => _missions;
  final _client = MissionsClient();

  final missionsController = StreamController();

  Stream<QuerySnapshot> get missionsStream =>
      _client.fetchMissions(teamId: teamID);

  Future<DocumentReference> addMission({@required Mission mission}) async {
    return await _client.addMission(teamId: teamID, mission: mission);
  }


  void standDownMission() {
    _client.standDownMission(detailMission);
  }

  void addAlarm(Alarm alarm) {
    _client.addAlarm(
      teamId: teamID,
      missionDocID: detailMission.reference.documentID,
      alarm: alarm,
    );
  }

  @override
  void dispose() {
    missionsController.close();
  }
}
