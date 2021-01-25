import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/page.dart' as missionpage;
import 'package:missionout/data_objects/response.dart';

abstract class Team {
  final String teamID;
  final String name;
  String chatURI; // URI for messaging app

  Team({@required this.teamID, @required this.name, this.chatURI});

  void launchChat();

  Stream<List<Mission>> fetchMissions();

  Stream<Mission> fetchSingleMission(
      {@required DocumentReference documentReference});

  Stream<List<Response>> fetchResponses(
      {@required DocumentReference documentReference});

  Future<Response> fetchUserResponse(
      {@required DocumentReference documentReference, @required String uid});

  Future<DocumentReference> addMission({@required Mission mission});

  void standDownMission({@required Mission mission});

  /// Interface with database. A page is uploaded to a server who will then act on the data
  Future addPage({
    @required missionpage.Page page,
  });

  Future updateChatURI(String chatURIVal);

  addResponse({
    @required Response response,
    @required String docID,
    @required String uid,
  });

  Future<DocumentReference> getDocumentReference(String path);
}
