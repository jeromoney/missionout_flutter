import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missionout/BLoC/bloc.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/mission_client.dart';
import 'package:flutter/foundation.dart';

class MissionsBloc implements Bloc {
  var _missions = <Mission>[];
  Mission _singleMission;
  final String _domain;

  MissionsBloc({@required String domain}) : this._domain = domain;

  List<Mission> get missions => _missions;
  final _client = MissionsClient();

  final missionsController = StreamController();

  Stream<QuerySnapshot> get missionsStream =>
      _client.fetchMissions(teamId: _domain);

  Stream<DocumentSnapshot> singleMissionStream({@required String docId}) =>
      _client.fetchSingleMissions(teamId: _domain, docId: docId);

  Future<DocumentReference> addMission({@required Mission mission}) async {
    return await _client.addMission(teamId: _domain, mission: mission);
  }

  Future<DocumentReference> addResponse(
      {@required String missionDocID, @required String uid}) async {
    return await _client.addResponse(
        teamId: _domain, missionDocID: missionDocID, uid: uid);
  }

  @override
  void dispose() {
    missionsController.close();
  }
}
