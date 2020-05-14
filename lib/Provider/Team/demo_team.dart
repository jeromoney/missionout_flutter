import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/geo_point.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/Provider/Team/team.dart';



class DemoTeam implements Team {
  List<Mission> missions = [
    Mission("Missing hiker", "need ground search team", "Passwater Gulch",
        GeoPoint(27.966389, 86.889999)),
    Mission("Injured skier", "snowmobilies report to bay", "Passwater Gulch",
        null),
    Mission("Overdue backpacker", "report to bay for search assignment", "Passwater Gulch",
        null),
    Mission("Empty boat found on river", "swiftwater team listen for assignments", "Passwater Gulch",
        null),
    Mission("Injured horserider ", "assist EMS with evacuation", "Passwater Gulch",
        null),
  ];

  List<Response> responses = [
    Response(teamMember: "Elton", status: "Responding"),
    Response(teamMember: "Ameera Lott", status: "Responding"),
    Response(teamMember: "Jazmine Burrows", status: "Delayed"),
    Response(teamMember: "Susie Diaz", status: "Standby"),
    Response(teamMember: "Eilish Watts", status: "Responding"),
  ];

  DemoTeam(){
    for (var i = 0; i < missions.length; i++){
      missions[i].reference = DemoReference(i);
    }
  }

  @override
  String chatURI;

  @override
  GeoPoint get location => GeoPoint(-49.350592,70.261962);

  @override
  String name;

  @override
  String teamID;

  @override
  Future<dynamic> addMission({Mission mission}) async {
    mission.time = Timestamp.now();
    missions.insert(0,mission);
    return DemoReference(0);
  }

  @override
  Future<void> addPage({Page page}) {
    // TODO: implement addPage
    return null;
  }

  @override
  addResponse({Response response, String docID, String uid}) {
    responses[0].status = response.status;
  }

  @override
  bool get chatURIisAvailable => false;

  @override
  // TODO: implement documentAddress
  get documentAddress => null;

  @override
  Stream<List<Mission>> fetchMissions() async* {
    yield missions;
  }

  @override
  Stream<List<Response>> fetchResponses({String docID}) async* {
    yield responses;
  }

  @override
  Stream<Mission> fetchSingleMission({String docID}) async* {
    yield missions[int.tryParse(docID) ?? 0];
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
  void set location(GeoPoint _location) {
    // TODO: implement location
  }

}


class DemoReference{

  String get address => documentID;
  String documentID;

  DemoReference(int i){
    documentID = i.toString();
  }
}

