import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:missionout/DataLayer/response.dart';

// TODO - Make Document Reference an abstract class

abstract class Database {
  String teamID;
  String uid;

  Stream<List<Mission>> fetchMissions();

  Stream<Mission> fetchSingleMission({@required String docID});

  Stream<List<Response>> fetchResponses({@required String docID});

  Future<DocumentReference> addMission({@required Mission mission}) async {}

  Future<void> addResponse({
    @required Response response,
    @required String docID,
  }) async {}

  void standDownMission({@required Mission mission});

  Future<void> addPage({@required Page page}) async {}

  Future<void> updatePhoneNumbers(
      {@required String mobilePhoneNumber,
      @required String voicePhoneNumber}) async {}
}
