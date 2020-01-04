import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:flutter/foundation.dart';

class MissionsClient {
  Stream<QuerySnapshot> fetchMissions({@required String teamId}) {
    const QUERY_LIMIT = 10;
    return Firestore.instance
        .collection('teams/$teamId/missions')
        .orderBy('time', descending: true)
        .limit(QUERY_LIMIT)
        .snapshots();
  }

  Stream<DocumentSnapshot> fetchSingleMissions(
      {@required String teamId, @required String docId}) {
    return Firestore.instance
        .document('teams/$teamId/missions/$docId')
        .snapshots();
  }

  Future<DocumentReference> addMission(
      {@required String teamId, @required Mission mission}) async {
    DocumentReference result = await Firestore.instance
        .collection('teams/$teamId/missions')
        .add(mission.toJson())
        .then((value) {
      return value;
    }).catchError((error) {
      print(error);
      return null; // returning null indicates problem with firebase. user probably should just retry
    });
    return result;
  }
}
