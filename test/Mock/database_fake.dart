import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/Provider/database.dart';

class DatabaseFake implements Database{
  @override
  Future<DocumentReference> addMission({String teamId, Mission mission}) {
    // TODO: implement addMission
    throw UnimplementedError();
  }

  @override
  Future<void> addPage({String teamID, String missionDocID, Page page}) {
    return null;
  }

  @override
  Future<void> addResponse({Response response, String teamID, String docID, String uid}) {
    return null;
  }

  @override
  Stream<List<Mission>> fetchMissions(String teamID) {
    // TODO: implement fetchMissions
    throw UnimplementedError();
  }

  @override
  Stream<List<Response>> fetchResponses({String teamID, String docID}) {
    // TODO: implement fetchResponses
    return null;
  }

  @override
  Stream<Mission> fetchSingleMission({String teamID, String docID}) {
    return null;
  }


  @override
  Future<void> updatePhoneNumbers({String uid, String mobilePhoneNumber, String voicePhoneNumber}) {
    // TODO: implement updatePhoneNumbers
    throw UnimplementedError();
  }

  @override
  void standDownMission({Mission mission, String teamID}) {
    return ;
  }

}