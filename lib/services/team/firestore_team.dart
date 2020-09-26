import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/page.dart' as missionpage;
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/services/team/team.dart';
import 'package:url_launcher/url_launcher.dart';

part 'firestore_team.g.dart';

@FirestoreDocument(hasSelfRef: false)
class FirestoreTeam implements Team {
  final _log = Logger('FirestoreTeam');
  final Firestore _db = Firestore.instance;
  @override
  @FirestoreAttribute(nullable: false)
  final String teamID;
  @override
  @FirestoreAttribute(nullable: false)
  final String name;
  @override
  String chatURI;

  FirestoreTeam({@required this.teamID, @required this.name, this.chatURI})
      : assert(teamID != null);

  static Future<FirestoreTeam> fromTeamID(String teamID) async {
    final log = Logger('FirestoreTeam');

    if (teamID == null) {
      log.warning("Team is null. User was not authenticated");
      throw ArgumentError.notNull(teamID);
    }

    final db = Firestore.instance;
    final DocumentSnapshot snapshot =
        await db.collection('teams').document(teamID).get();
    return FirestoreTeam.fromSnapshot(snapshot);
  }

  factory FirestoreTeam.fromSnapshot(DocumentSnapshot snapshot) =>
      _$firestoreTeamFromSnapshot(snapshot);

  @override
  void launchChat() => launch(chatURI);

  // firestore reads

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
  Stream<Mission> fetchSingleMission(
      {@required DocumentReference documentReference}) {
    return _db
        .document(documentReference.path)
        .snapshots()
        .map((snapshot) => Mission.fromSnapshot(snapshot));
  }

  @override
  Future<Response> fetchUserResponse(
      {@required DocumentReference documentReference,
      @required String uid}) async {
    final snapshot =
        await _db.document("${documentReference.path}/responses/$uid").get();
    if (snapshot.data == null) return null;
    return Response.fromSnapshot(snapshot);
  }

  @override
  Stream<List<Response>> fetchResponses(
      {@required DocumentReference documentReference}) {
    final ref = _db
        .collection('${documentReference.path}/responses')
        .orderBy('status', descending: true);
    return ref.snapshots().map((snapShots) => snapShots.documents
        .map((data) => Response.fromSnapshot(data))
        .toList());
  }

  // firestore writes

  @override
  Future updateChatURI(String chatURIVal) async {
    await _db.document('teams/$teamID').updateData({
      'chatURI': chatURIVal,
    });
    chatURI = chatURIVal;
  }

  @override
  Future<DocumentReference> addMission({
    @required Mission mission,
  }) async {
    // if document reference exists in mission variable, than we are updating an existing mission rather than creating a new one.
    DocumentReference result;
    if (mission.selfRef == null) {
      // reference doesn't exist so create new mission
      result = await _db
          .collection('teams/$teamID/missions')
          .add(mission.toMap())
          .then((value) {
        return value;
      }).catchError((error) {
        _log.warning('Error adding mission to Firestore', error);
        return null; // returning null indicates problem with firebase. user probably should just retry
      });
      return result;
    } else {
      // reference is not null so we just update mission.
      await mission.selfRef.setData(mission.toMap(), merge: true);
      result = mission.selfRef;
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
        .document('teams/$teamID/missions/${mission.selfRef.documentID}')
        .updateData({'isStoodDown': mission.isStoodDown});
  }

  @override
  Future<void> addPage({
    @required missionpage.Page page,
  }) async {
    String missionDocId = page.address;
    await _db
        .collection('teams/$teamID/missions/$missionDocId/pages')
        .add(page.toJson())
        .then((documentReference) {
      return;
    }).catchError((error) {
      _log.warning('error in adding page to firestore.', error);
    });
  }
}
