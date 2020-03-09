import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Response {
  final String teamMember;
  final String status;
  String drivingTime;
  DocumentReference reference;

  Response({@required String teamMember, @required String status})
      : this.teamMember = teamMember,
        this.status = status,
        this.drivingTime = null,
        this.reference = null;

  Response.fromMap(Map<String, dynamic> map, {this.reference})
      : teamMember = map['teamMember'],
        status = map['status'],
        drivingTime = map['driving_time'];

  Response.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toJson() => {
        'teamMember': teamMember,
        'status': status,
        'time':  FieldValue.serverTimestamp(),
      };
}
