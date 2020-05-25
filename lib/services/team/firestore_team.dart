import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/page.dart' as missionpage;
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/services/team/team.dart';
import 'package:url_launcher/url_launcher.dart';

class FirestoreTeam implements Team {
  final Firestore _db = Firestore.instance;
  @override
  final String teamID;
  @override
  final String name;
  @override
  GeoPoint location;
  @override
  String chatURI;

  FirestoreTeam(
      {@required this.teamID, @required this.name, this.location, this.chatURI})
      : assert(teamID != null);

  @override
  dynamic get documentAddress => _firestoreDocumentAddress != null;

  DocumentReference _firestoreDocumentAddress;

  @override
  void launchChat() {
    launch(chatURI);
  }

  @override
  Future updateLocation(GeoPoint locationVal) async {
    await _db.document('teams/$teamID').updateData({
      'location': locationVal,
    }).catchError((error) {
      throw error;
    });
    location = locationVal;
  }

  @override
  Future updateChatURI(String chatURIVal) async {
    await _db.document('teams/$teamID').updateData({
      'chatURI': chatURIVal,
    }).catchError((error) {
      throw error;
    });
    chatURI = chatURIVal;
  }

  @override
  Stream<List<Mission>> fetchMissions() {
    const QUERY_LIMIT = 5;
    final ref = _db
        .collection('teams/$teamID/missions')
        .limit(QUERY_LIMIT)
        .orderBy('time', descending: true);
    return ref.snapshots().map((snapShots) =>
        snapShots.documents.map((data) => Mission.fromSnapshot(data)).toList());
  }

  @override
  Stream<Mission> fetchSingleMission({@required String docID}) {
    return _db
        .document('teams/$teamID/missions/$docID')
        .snapshots()
        .map((snapshot) => Mission.fromSnapshot(snapshot));
  }

  @override
  Stream<List<Response>> fetchResponses({@required String docID}) {
    final ref = _db
        .collection('teams/$teamID/missions/$docID/responses')
        .orderBy('status', descending: true);
    return ref.snapshots().map((snapShots) => snapShots.documents
        .map((data) => Response.fromSnapshot(data))
        .toList());
  }

  @override
  Future<DocumentReference> addMission({
    @required Mission mission,
  }) async {
    // if document reference exists in mission variable, than we are updating an existing mission rather than creating a new one.
    DocumentReference result;
    if (mission.reference == null) {
      // reference doesn't exist so create new mission
      result = await _db
          .collection('teams/$teamID/missions')
          .add(mission.toDatabase())
          .then((value) {
        return value;
      }).catchError((error) {
        print(error);
        return null; // returning null indicates problem with firebase. user probably should just retry
      });
      return result;
    } else {
      // reference is not null so we just update mission.
      await mission.reference.setData(mission.toDatabase(), merge: true);
      result = mission.reference;
    }
    return result;
  }

  @override
  addResponse({
    @required Response response,
    @required String docID,
    @required String uid,
  }) async {
    DocumentReference document =
        _db.collection('teams/$teamID/missions/$docID/responses').document(uid);
    if (response != null) {
      await document.setData(response.toJson());
    } else {
      await document.delete();
    }
  }

  @override
  void standDownMission({
    @required Mission mission,
  }) {
    _db
        .document('teams/$teamID/missions/${mission.reference.documentID}')
        .updateData({'isStoodDown': mission.isStoodDown});
  }

  @override
  Future<void> addPage({
    @required missionpage.Page page,
  }) async {
    String missionDocId = page.mission.address;
    await _db
        .collection('teams/$teamID/missions/$missionDocId/pages')
        .add(page.toJson())
        .then((documentReference) {
      return;
    }).catchError((error) {
      print('error');
    });
  }
}
