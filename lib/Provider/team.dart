import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class Team {
  String name;
  String teamID;
  GeoPoint location;
  String chatURI; // URI for messaging app
  bool get chatURIisAvailable;
  dynamic get documentAddress; // Where the document is in database
  Team.fromDatabase(dynamic importFormat);
  dynamic toDatabase();

  void updateTeamID(String teamID);

  Future<void> updateInfo({@required GeoPoint geoPoint, @required String chatUri});

  void launchChat();

}
