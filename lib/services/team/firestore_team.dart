import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/page.dart' as missionpage;
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/services/team/team.dart';
import 'package:url_launcher/url_launcher.dart';

part 'firestore_team.g.dart';

@JsonSerializable()
class FirestoreTeam implements Team {
  final _log = Logger('FirestoreTeam');
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  @override
  final String teamID;
  @override
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

    final db = FirebaseFirestore.instance;
    final DocumentSnapshot snapshot =
        await db.collection('teams').doc(teamID).get();
    return FirestoreTeam.fromSnapshot(snapshot);
  }

  factory FirestoreTeam.fromSnapshot(DocumentSnapshot snapshot) =>
      _$FirestoreTeamFromJson(snapshot.data());

  @override
  void launchChat() => launch(chatURI);

  // firestore reads

  @override
  Stream<List<Mission>> fetchMissions() {
    const queryLimit = 5;
    final ref = _db
        .collection('teams/$teamID/missions')
        .limit(queryLimit)
        .orderBy('time', descending: true);
    return ref.snapshots().map((snapShots) =>
        snapShots.docs.map((data) => Mission.fromSnapshot(data)).toList());
  }

  @override
  Stream<Mission> fetchSingleMission(
      {@required DocumentReference documentReference}) {
    return _db
        .doc(documentReference.path)
        .snapshots()
        .map((snapshot) => Mission.fromSnapshot(snapshot));
  }

  @override
  Future<Response> fetchUserResponse(
      {@required DocumentReference documentReference,
      @required String uid}) async {
    final snapshot =
        await _db.doc("${documentReference.path}/responses/$uid").get();
    if (snapshot.data == null || !snapshot.exists) return null;
    return Response.fromSnapshot(snapshot);
  }

  @override
  Stream<List<Response>> fetchResponses(
      {@required DocumentReference documentReference}) {
    final ref = _db
        .collection('${documentReference.path}/responses')
        .orderBy('status', descending: true);
    return ref.snapshots().map((snapShots) =>
        snapShots.docs.map((data) => Response.fromSnapshot(data)).toList());
  }

  // firestore writes

  @override
  Future updateChatURI(String chatURIVal) async {
    await _db.doc('teams/$teamID').update({
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
    if (mission.documentReference == null) {
      // reference doesn't exist so create new mission
      return _db
          .collection('teams/$teamID/missions')
          .add(mission.toMap())
          .then((value) {
        return value;
      }).catchError((error) {
        _log.warning('Error adding mission to Firestore', error);
        return null; // returning null indicates problem with firebase. user probably should just retry
      });
    } else {
      // reference is not null so we just update mission.
      await mission.documentReference
          .set(mission.toMap(), SetOptions(merge: true));
      result = mission.documentReference;
    }
    return result;
  }

  @override
  Future addResponse({
    @required Response response,
    @required String docID,
    @required String uid,
  }) async {
    final document =
        _db.collection('teams/$teamID/missions/$docID/responses').doc(uid);
    if (response != null) {
      await document.set(response.toJson());
    } else {
      await document.delete();
    }
  }

  @override
  void standDownMission({
    @required Mission mission,
  }) {
    _db
        .doc('teams/$teamID/missions/${mission.address}')
        .update({'isStoodDown': mission.isStoodDown});
  }

  @override
  Future addPage({
    @required missionpage.Page page,
  }) async {
    final pageCollection = '/${page.missionDocumentPath}/pages';
    await _db
        .collection(pageCollection)
        .add(page.toJson())
        .then((documentReference) {
      return;
    }).catchError((error) {
      _log.warning('error in adding page to firestore.', error);
    });
  }

  @override
  Future<DocumentReference> getDocumentReference(String path) async {
    // This is a bit hackish. Opens the most recent mission rather than the specific
    // mission. Problems could arise with multiple missions
    // TODO- fix the hack to be more specific
    return _db.doc(path);
  }
}
