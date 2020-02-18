import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/Provider/team.dart';
import 'package:url_launcher/url_launcher.dart';

class FirestoreTeam implements Team {
  @override
  String name;
  @override
  String teamID;
  @override
  GeoPoint location;
  @override
  String chatURI;

  @override
  FirestoreTeam.fromDatabase(dynamic importFormat);

  @override
  dynamic get documentAddress => _firestoreDocumentAddress != null;

  @override
  bool get chatURIisAvailable => chatURI != null;

  DocumentReference _firestoreDocumentAddress;

  FirestoreTeam();

  FirestoreTeam.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        location = map['location'],
        chatURI = map['chatURI'];

  @override
  dynamic toDatabase() {}

  @override
  void launchChat() {
    launch(chatURI);
  }

  @override
  void updateTeamID(String teamID) async {
    this.teamID = teamID;
    final Firestore db = Firestore.instance;
    // user specific permissions
    var document = await db.collection('teams').document(teamID).get();
    var data = document.data;
    name = data['name'] ?? '';
    location = data['location'];
    chatURI = data['chatURI'];
  }

  @override
  Future<void> updateInfo({@required GeoPoint geoPoint, @required String chatUri}) async {
    final Firestore db = Firestore.instance;
    await db.document('teams/$teamID').updateData({
      'chatURI': chatUri,
      'location': geoPoint
    }).then((value) {
      return true;
    }).catchError((error) {
      throw error;
    });

  }
}
