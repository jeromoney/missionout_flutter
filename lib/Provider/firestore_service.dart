import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:missionout/DataLayer/response.dart';

class FirestoreService {
  final Firestore _db = Firestore.instance;

  Stream<List<Mission>> fetchMissions(String teamID) {
    const QUERY_LIMIT = 10;
    final ref = _db
        .collection('teams/$teamID/missions')
        .limit(QUERY_LIMIT)
        .orderBy('time', descending: true);
    return ref.snapshots().map((snapShots) =>
        snapShots.documents.map((data) => Mission.fromSnapshot(data)).toList());
  }

  Stream<Mission> fetchSingleMission(
      {@required String teamID, @required String docID}) {
    return _db
        .document('teams/$teamID/missions/$docID')
        .snapshots()
        .map((snapshot) => Mission.fromSnapshot(snapshot));
  }

  fetchResponses({@required String teamID, @required String docID}) {
    final ref = _db
        .collection('teams/$teamID/missions/$docID/responses')
        .orderBy('status', descending: true);
    return ref.snapshots().map((snapShots) => snapShots.documents
        .map((data) => Response.fromSnapshot(data))
        .toList());
  }

  Future<DocumentReference> addMission(
      {@required String teamId, @required Mission mission}) async {
    // if document reference exists in mission variable, than we are updating an existing mission rather than creating a new one.
    DocumentReference result;
    if (mission.reference == null) {
      // reference doesn't existm so create new mission
      result = await _db
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
      await mission.reference.setData(mission.toJson(), merge: true);
      result = mission.reference;
    }
    return result;
  }

  Future<void> addResponse(
      {@required Response response,
      @required String teamID,
      @required String docID,
      @required String uid}) async {
    DocumentReference document =
        _db.collection('teams/$teamID/missions/$docID/responses').document(uid);
    if (response != null) {
      await document.setData(response.toJson());
    } else {
      await document.delete();
    }
  }

  void standDownMission(
      {bool standDown, @required String teamID, @required String docID}) {
    _db
        .document('teams/$teamID/missions/$docID')
        .updateData({'stoodDown': standDown});
  }

  Future<void> addPage(
      {@required String teamID,
      @required String missionDocID,
      @required Page page}) async {
    await _db
        .collection('teams/$teamID/missions/$missionDocID/pages')
        .add(page.toJson())
        .then((documentReference) {
      return;
    }).catchError((error) {
      print('error');
    });
  }

  Future<void> updatePhoneNumbers({@required String uid,
    @required String mobilePhoneNumber, @required String voicePhoneNumber}) async {
    await _db.document('users/$uid').updateData({
      'mobilePhoneNumber': mobilePhoneNumber,
      'voicePhoneNumber': voicePhoneNumber
    }).then((value) {
      return true;
    }).catchError((error) {
      throw error;
    });
  }
}
