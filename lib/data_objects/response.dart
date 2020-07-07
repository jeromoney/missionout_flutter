import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

part 'response.g.dart';

@FirestoreDocument(hasSelfRef: false)
class Response {
  final String teamMember;
  final String status;
  final Timestamp time;

  Response(
      {@required this.teamMember,
      @required this.status,
      this.time,
      hashCode}); // Hacky- there is a bug in the firestore_annotations where hashCode is not being ignored. This allows the generated code to work

  Response.fromApp({@required this.teamMember, @required this.status})
      : time = Timestamp.now();

  factory Response.fromSnapshot(DocumentSnapshot snapshot) =>
      _$responseFromSnapshot(snapshot);

  Map<String, dynamic> toJson() => _$responseToMap(this);

  @override
  bool operator ==(other) {
    return other.teamMember == teamMember;
  }

  @override
  int get hashCode => ((teamMember ?? "") + (status ?? "")).hashCode;
}
