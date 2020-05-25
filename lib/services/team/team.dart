import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/page.dart' as missionpage;
import 'package:missionout/data_objects/response.dart';

abstract class Team {
  final String teamID;
  final String name;
   GeoPoint location;
   String chatURI; // URI for messaging app

  Team({@required this.teamID, @required this.name, this.location, this.chatURI});

  dynamic get documentAddress; // Where the document is in database

  void launchChat();

  Stream<List<Mission>> fetchMissions();

  Stream<Mission> fetchSingleMission({@required String docID});

  Stream<List<Response>> fetchResponses({@required String docID});

  Future<dynamic> addMission({@required Mission mission});

  void standDownMission({@required Mission mission});

  /// Interface with database. A page is uploaded to a server who will then act on the data
  Future<void> addPage({
    @required missionpage.Page page,
  });

  Future updateLocation(GeoPoint locationVal);

  Future updateChatURI(String chatURIVal);


  addResponse({
    @required Response response,
    @required String docID,
    @required String uid,
  });
}
