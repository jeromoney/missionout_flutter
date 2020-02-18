import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/Provider/team.dart';

class TeamFake implements Team{
  @override
  String name;
  @override
  String teamID;
  @override
  GeoPoint location;
  @override
  String chatURI;

  TeamFake({this.chatURI = 'https://something.com'});

  @override
  bool get chatURIisAvailable => true;

  @override
  dynamic get documentAddress {

  }

  @override
  dynamic toDatabase() {

  }

  @override
  void updateTeamID(String teamID) {

  }

  @override
  void launchChat() {
    if (chatURI == 'this will cause an error') {throw DiagnosticLevel.error;}
  }

  @override
  Future<Function> updateInfo(
      {@required GeoPoint geoPoint, @required String chatUri}) {

  }
}