import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/Provider/team.dart';
import 'package:url_launcher/url_launcher.dart';

class FirestoreTeam implements Team {
  final Firestore _db = Firestore.instance;

  @override
  String name;
  @override
  String teamID;
  @override
  GeoPoint location;
  @override
  String chatURI;

  @override
  FirestoreTeam.fromDatabase(dynamic importFormat);


  FirestoreTeam();

  FirestoreTeam.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        location = map['location'],
        chatURI = map['chatURI'];
  @override
  dynamic get documentAddress => _firestoreDocumentAddress != null;

  @override
  bool get chatURIisAvailable => chatURI != null;

  DocumentReference _firestoreDocumentAddress;

  @override
  void launchChat() {
    launch(chatURI);
  }

  @override
  void updateTeamID(String teamID) async {
    if (teamID == null) {
      return;
    }
    this.teamID = teamID;
    // user specific permissions
    var document = await _db.collection('teams').document(teamID).get();
    var data = document.data;
    name = data['name'] ?? '';
    location = data['location'];
    chatURI = data['chatURI'];
  }

  @override
  Future<void> updateInfo(
      {@required GeoPoint geoPoint, @required String chatUri}) async {
    await _db
        .document('teams/$teamID')
        .updateData({'chatURI': chatUri, 'location': geoPoint}).then((value) {
      return true;
    }).catchError((error) {
      throw error;
    });
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
  Future<void> addResponse({
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
    @required Page page,
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
