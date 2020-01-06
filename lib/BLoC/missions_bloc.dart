import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missionout/BLoC/bloc.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/mission_client.dart';
import 'package:flutter/foundation.dart';
import 'package:missionout/DataLayer/response.dart';

class MissionsBloc implements Bloc {
  var _missions = <Mission>[];
  Mission detailMission;
  String domain;

  List<Mission> get missions => _missions;
  final _client = MissionsClient();

  final missionsController = StreamController();

  Stream<QuerySnapshot> get missionsStream =>
      _client.fetchMissions(teamId: domain);

  Stream<DocumentSnapshot> singleMissionStream({@required String docId}) =>
      _client.fetchSingleMissions(teamId: domain, docId: docId);

  Future<DocumentReference> addMission({@required Mission mission}) async {
    return await _client.addMission(teamId: domain, mission: mission);
  }

  Future<void> addResponse(
      {@required Response response,
      @required String missionDocID,
      @required String uid}) async {
    return await _client.addResponse(
        response: response,
        teamId: domain,
        missionDocID: missionDocID,
        uid: uid);
  }

  @override
  void dispose() {
    missionsController.close();
  }
}
