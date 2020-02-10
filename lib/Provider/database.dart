import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:missionout/DataLayer/response.dart';

// TODO - Make Document Reference an abstract class
// TODO - Organize parameters to have more consistency

abstract class Database {
  Stream<List<Mission>> fetchMissions(String teamID) {}

  Stream<Mission> fetchSingleMission(
      {@required String teamID, @required String docID}) {}

  Stream<List<Response>> fetchResponses({@required String teamID, @required String docID}) {}

  Future<DocumentReference> addMission(
      {@required String teamId, @required Mission mission}) async {}

  Future<void> addResponse(
      {@required Response response,
      @required String teamID,
      @required String docID,
      @required String uid}) async {}

  void standDownMission(
      {@required Mission mission, @required String teamID}) {}

  Future<void> addPage(
      {@required String teamID,
      @required Page page}) async {}

  Future<void> updatePhoneNumbers(
      {@required String uid,
      @required String mobilePhoneNumber,
      @required String voicePhoneNumber}) async {}
}
