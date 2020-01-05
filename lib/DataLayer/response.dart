import 'package:cloud_firestore/cloud_firestore.dart';

class Response {
  final String teamMember;
  final String status;
  final String drivingTime;
  final DocumentReference reference;

  Response(teamMember, status, drivingTime)
      : this.teamMember = teamMember,
        this.status = status,
        this.drivingTime = drivingTime,
        this.reference = null;

  Response.fromMap(Map<String, dynamic> map, {this.reference})
      : teamMember = map['name'],
        status = map['status'],
        drivingTime = map['driving_time'];

  Response.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toJson() => {
    'teamMember': teamMember,
    'status': status,
    'time': FieldValue.serverTimestamp(),
  };
}
