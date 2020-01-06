import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:flutter/foundation.dart';
import 'package:missionout/DataLayer/response.dart';

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
    // if document reference exists in mission variable, than we are updating an existing mission rather than creating a new one.
    DocumentReference result;
    if (mission.reference == null) {
      // reference doesn't existm so create new mission
      result = await Firestore.instance
          .collection('teams/$teamId/missions')
          .add(mission.toJson())
          .then((value) {
        return value;
      }).catchError((error) {
        print(error);
        return null; // returning null indicates problem with firebase. user probably should just retry
      });
      return result;
    } else {
      // reference is not null so we just update mission.
      final dickbutt = mission.toJson();
      await mission.reference.setData(dickbutt, merge: true);
      result = mission.reference;
    }
    return result;
  }

  Future<void> addResponse(
      {@required String teamId,
      @required String missionDocID,
      @required String uid,
      @required Response response}) async {
    await Firestore.instance
        .collection('teams/$teamId/missions/$missionDocID/responses')
        .document(uid)
        .setData(response.toJson())
        .catchError((error) {
      return error;
    });
  }
}
