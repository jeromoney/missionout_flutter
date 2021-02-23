import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/page.dart';
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/services/team/team.dart';

class MockTeam implements Team{
  @override
  Future<DocumentReference> addMission({Mission mission}) {
    // TODO: implement addMission
    throw UnimplementedError();
  }

  @override
  Future addPage({Page page}) {
    // TODO: implement addPage
    throw UnimplementedError();
  }

  @override
  addResponse({Response response, String docID, String uid}) {
    // TODO: implement addResponse
    throw UnimplementedError();
  }

  @override
  Stream<List<Mission>> fetchMissions() {
    // TODO: implement fetchMissions
    throw UnimplementedError();
  }

  @override
  Stream<List<Response>> fetchResponses({DocumentReference documentReference}) {
    // TODO: implement fetchResponses
    throw UnimplementedError();
  }

  @override
  Stream<Mission> fetchSingleMission({DocumentReference documentReference}) {
    // TODO: implement fetchSingleMission
    throw UnimplementedError();
  }

  @override
  Future<Response> fetchUserResponse({DocumentReference documentReference, String uid}) {
    // TODO: implement fetchUserResponse
    throw UnimplementedError();
  }

  @override
  Future<DocumentReference> getDocumentReference(String path) {
    // TODO: implement getDocumentReference
    throw UnimplementedError();
  }

  @override
  void launchChat() {
    // TODO: implement launchChat
  }

  @override
  void standDownMission({Mission mission}) {
    // TODO: implement standDownMission
  }

  @override
  Future updateChatURI(String chatURIVal) {
    // TODO: implement updateChatURI
    throw UnimplementedError();
  }

  @override
  String chatURI;

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  String get teamID => "2345566";
  
}