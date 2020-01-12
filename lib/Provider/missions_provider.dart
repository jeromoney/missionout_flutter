import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/mission_client.dart';
import 'package:flutter/foundation.dart';

class MissionsProvider with ChangeNotifier {
  MissionsProvider({@required String teamID}) : _teamID = teamID;
  final String _teamID;
  
  List<Mission> _missions = <Mission>[];
  List<Mission> get missions => _missions;

  final _client = MissionsClient();

  Stream<List<Mission>> get missionsStream {
    return _client
        .fetchMissions(teamId: _teamID)
        .map((querySnapshot) => querySnapshot.documents.map((document)=>Mission.fromSnapshot(document)));
  }
  
  Future<void> fetchMissions(){
    _client.fetchMissions(teamId: _teamID);
  }
  

  Future<DocumentReference> addMission({@required Mission mission}) async {
    return await _client.addMission(teamId: _teamID, mission: mission);
  }



  @override
  void dispose() {
  }
}
