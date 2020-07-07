import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/page.dart' as my;
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/services/team/team.dart';

class DemoTeam with ChangeNotifier implements Team {
  List<Mission> _missions = [
    Mission.fromApp(
        description: "Missing hiker",
        needForAction: "need ground search team",
        locationDescription: "Passwater Gulch",
        location: GeoPoint(27.966389, 86.889999)),
    Mission.fromApp(
      description: "Injured skier",
      needForAction: "snowmobilies report to bay",
      locationDescription: "Passwater Pass",
    ),
    Mission.fromApp(
        description: "Overdue backpacker",
        needForAction: "report to bay for search assignment",
        locationDescription: "Frontwind Gulch"),
    Mission.fromApp(
        description: "Empty boat found on river",
        needForAction: "swiftwater team listen for assignments",
        locationDescription: "Passwater Bay"),
    Mission.fromApp(
        description: "Injured horserider ",
        needForAction: "assist EMS with evacuation",
        locationDescription: "Passwater Gulch"),
  ];

  List<Response> _responses = [
    Response.fromApp(teamMember: "Ameera Lott", status: "Responding"),
    Response.fromApp(teamMember: "Jazmine Burrows", status: "Delayed"),
    Response.fromApp(teamMember: "Susie Diaz", status: "Standby"),
    Response.fromApp(teamMember: "Eilish Watts", status: "Responding"),
    Response.fromApp(teamMember: "Deanna Mora", status: "Responding"),
    Response.fromApp(teamMember: "Addie Vega", status: "Delayed"),
    Response.fromApp(teamMember: "Franco Bolton", status: "Standby"),
    Response.fromApp(teamMember: "Grayson Burch", status: "Responding"),
    Response.fromApp(teamMember: "Levi Hinton", status: "Responding"),
    Response.fromApp(teamMember: "Karishma Appleton", status: "Delayed"),
    Response.fromApp(teamMember: "Myles Pollard", status: "Standby"),
    Response.fromApp(teamMember: "Ariah Snow", status: "Responding"),
    Response.fromApp(teamMember: "Lola-Rose Rudd", status: "Responding"),
    Response.fromApp(teamMember: "Kiyan Jones", status: "Delayed"),
    Response.fromApp(teamMember: "Leanna Travers", status: "Standby"),
    Response.fromApp(teamMember: "Vivaan Morton", status: "Responding"),
  ];

  DemoTeam() {
    for (var i = 0; i < _missions.length; i++) {
      _missions[i].selfRef = DemoReference(i) as DocumentReference; //TODO - this will probably break
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
    if (response == null) {
      // User deselected response, so remove it
      int i = _responses.indexOf(Response.fromApp(teamMember: "Elton", status: null));
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

  @override
  Future updateChatURI(String chatURIVal) {
    // TODO: implement updateChatURI
    throw UnimplementedError();
  }

  @override
  Future updateLocation(GeoPoint locationVal) {
    // TODO: implement updateLocation
    throw UnimplementedError();
  }
}

class DemoReference {
  String get address => documentID;
  String documentID;

  DemoReference(int i) {
    documentID = i.toString();
  }
}
