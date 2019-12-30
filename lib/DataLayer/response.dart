import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Response {
  final String team_member;
  final String status;
  final String driving_time;
  final DocumentReference reference;

  Response(@required team_member, status, driving_time)
      : this.team_member = team_member,
        this.status = status,
        this.driving_time = driving_time,
        this.reference = null;

  Response.fromMap(Map<String, dynamic> map, {this.reference})
      : team_member = map['name'],
        status = map['response'],
        driving_time = map['driving_time'];

  Response.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
