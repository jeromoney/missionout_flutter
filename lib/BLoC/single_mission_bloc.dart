import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/BLoC/bloc.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/DataLayer/single_mission_client.dart';

class SingleMissionBloc extends Bloc {
  SingleMissionBloc(
      {@required String teamDocID,
      @required String docID,
      @required String uid})
      : this._client =
            SingleMissionClient(teamDocID: teamDocID, docID: docID, uid: uid);
  final SingleMissionClient _client;

  Stream<Mission> get mission {
    Stream<DocumentSnapshot> _clientStream = _client.fetchSingleMission();
    return _clientStream
        .map((documentSnapshot) => Mission.fromSnapshot(documentSnapshot));
  }

  Future<void> addResponse(
      {@required Response response}) async {
    return await _client.addResponse(response: response);
  }

  @override
  void dispose() {
    mission.drain();
  }
}
