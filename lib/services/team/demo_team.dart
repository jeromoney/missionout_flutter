import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/page.dart' as my;
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/Provider/Team/team.dart';

class DemoTeam with ChangeNotifier implements Team {
  List<Mission> _missions = [
    Mission("Missing hiker", "need ground search team", "Passwater Gulch",
        GeoPoint(27.966389, 86.889999)),
    Mission(
        "Injured skier", "snowmobilies report to bay", "Passwater Gulch", null),
    Mission("Overdue backpacker", "report to bay for search assignment",
        "Passwater Gulch", null),
    Mission("Empty boat found on river",
        "swiftwater team listen for assignments", "Passwater Gulch", null),
    Mission("Injured horserider ", "assist EMS with evacuation",
        "Passwater Gulch", null),
  ];

  List<Response> _responses = [
    Response(teamMember: "Ameera Lott", status: "Responding"),
    Response(teamMember: "Jazmine Burrows", status: "Delayed"),
    Response(teamMember: "Susie Diaz", status: "Standby"),
    Response(teamMember: "Eilish Watts", status: "Responding"),
    Response(teamMember: "Deanna Mora", status: "Responding"),
    Response(teamMember: "Addie Vega", status: "Delayed"),
    Response(teamMember: "Franco Bolton", status: "Standby"),
    Response(teamMember: "Grayson Burch", status: "Responding"),
    Response(teamMember: "Levi Hinton", status: "Responding"),
    Response(teamMember: "Karishma Appleton", status: "Delayed"),
    Response(teamMember: "Myles Pollard", status: "Standby"),
    Response(teamMember: "Ariah Snow", status: "Responding"),
    Response(teamMember: "Lola-Rose Rudd", status: "Responding"),
    Response(teamMember: "Kiyan Jones", status: "Delayed"),
    Response(teamMember: "Leanna Travers", status: "Standby"),
    Response(teamMember: "Vivaan Morton", status: "Responding"),
  ];

  DemoTeam() {
    for (var i = 0; i < _missions.length; i++) {
      _missions[i].reference = DemoReference(i);
    }
  }

  @override
  String chatURI;

  @override
  GeoPoint get location => GeoPoint(-49.350592, 70.261962);

  @override
  String name;

  @override
  String teamID = "demo_user.com";

  @override
  Future<dynamic> addMission(
      {Mission mission, bool onlyEditors = false}) async {
    mission.time = Timestamp.now();
    _missions.insert(0, mission);
    return DemoReference(0);
  }
  @override
  bool get isInitialized => true;

  @override
  Future<void> addPage({my.Page page}) {
    // TODO: implement addPage
    return null;
  }

  @override
  addResponse({Response response, String docID, String uid}) {
    if (response == null) { // User deselected response, so remove it
      int i = _responses.indexOf(Response(teamMember: "Elton", status: null));
      _responses.removeAt(i);
      return;
    }
    int i = _responses.indexOf(response);
    if (i == -1) // response not in list
      _responses.add(response);
    else // found response, so replacing with new one
      _responses[i] = response;
  }

  @override
  bool get chatURIisAvailable => false;

  @override
  // TODO: implement documentAddress
  get documentAddress => null;

  @override
  Stream<List<Mission>> fetchMissions() async* {
    yield _missions;
  }

  @override
  Stream<List<Response>> fetchResponses({String docID}) async* {
    yield _responses;
  }

  @override
  Stream<Mission> fetchSingleMission({String docID}) async* {
    yield _missions[int.tryParse(docID) ?? 0];
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

class DemoReference {
  String get address => documentID;
  String documentID;

  DemoReference(int i) {
    documentID = i.toString();
  }
}
