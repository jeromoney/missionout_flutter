import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:missionout/DataLayer/response.dart';

abstract class Team {
  String name;
  String teamID;
  GeoPoint location;
  String chatURI; // URI for messaging app
  bool get chatURIisAvailable;

  dynamic get documentAddress; // Where the document is in database
  Team.fromDatabase(dynamic importFormat);

  dynamic toDatabase();

  void updateTeamID(String teamID);

  Future<void> updateInfo(
      {@required GeoPoint geoPoint, @required String chatUri});

  void launchChat();

  Stream<List<Mission>> fetchMissions();

  Stream<Mission> fetchSingleMission({@required String docID});

  Stream<List<Response>> fetchResponses({@required String docID});

  Future<DocumentReference> addMission({@required Mission mission});

  void standDownMission({@required Mission mission});

  Future<void> addPage({
    @required Page page,
    @required String missionDocID,
  });

  // Interface with database. A page is uploaded to a server who will then act on the data

  Future<void> addResponse({
    @required Response response,
    @required String docID,
    @required String uid,
  });
}
