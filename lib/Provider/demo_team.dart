import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/geo_point.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/Provider/team.dart';

List<Mission> MISSIONS = [
  Mission("Missing hiker", "need ground search team", "Passwater Gulch",
      GeoPoint(27.966389, 86.889999)),
  Mission("Injured skier", "snowmobilies report to bay", "Passwater Gulch",
      null),
  Mission("Overdue backpacker", "report to bay for search assignment", "Passwater Gulch",
      null),
  Mission("Empty boat found on river", "swiftwater team listen for assignemnts", "Passwater Gulch",
      null),
  Mission("Injured horserider ", "assist EMS with evacuation", "Passwater Gulch",
      null),
];
List<Response> RESPONSES = [
  Response(teamMember: "Elton", status: "Responding"),
  Response(teamMember: "Ameera Lott", status: "Responding"),
  Response(teamMember: "Jazmine Burrows", status: "Delayed"),
  Response(teamMember: "Susie Diaz", status: "Standby"),
  Response(teamMember: "Eilish Watts", status: "Responding"),
];

class DemoTeam implements Team {
  @override
  String chatURI;

  @override
  GeoPoint location;

  @override
  String name;

  @override
  String teamID;

  @override
  Future<DocumentReference> addMission({Mission mission}) {
    // TODO: implement addMission
    return null;
  }

  @override
  Future<void> addPage({Page page}) {
    // TODO: implement addPage
    return null;
  }

  @override
  Future<void> addResponse({Response response, String docID, String uid}) {
    // TODO: implement addResponse
    return null;
  }

  @override
  bool get chatURIisAvailable => false;

  @override
  // TODO: implement documentAddress
  get documentAddress => null;

  @override
  Stream<List<Mission>> fetchMissions() async* {
    yield MISSIONS;
  }

  @override
  Stream<List<Response>> fetchResponses({String docID}) async* {
    yield RESPONSES;
  }

  @override
  Stream<Mission> fetchSingleMission({String docID}) async* {
    yield MISSIONS[0];
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
  Future<void> updateInfo({GeoPoint geoPoint, String chatUri}) {
    // TODO: implement updateInfo
    return null;
  }

  @override
  void updateTeamID(String teamID) {
    // TODO: implement updateTeamID
  }
}
