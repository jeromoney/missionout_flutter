import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:missionout/data_objects/json_converters.dart';

part 'response.g.dart';

@immutable
@JsonSerializable()
class Response {
  @JsonKey(ignore: true)
  static const RESPONSES = ['Responding', 'Delayed', 'Standby', 'Unavailable'];
  @JsonKey(ignore: true)
  final DocumentReference documentReference;
  final String teamMember;
  final String status;
  @TimestampJsonConverter()
  final Timestamp time;

  Response({
    @required this.teamMember,
    @required this.status,
    this.documentReference,
    this.time,
  });

  Response.fromApp({@required this.teamMember, @required this.status})
      : time = Timestamp.now(),
        this.documentReference = null;

  Response addDocumentReference(
          {@required DocumentReference documentReference}) =>
      Response(
          documentReference: documentReference,
          teamMember: teamMember,
          status: status,
          time: time);

  factory Response.fromSnapshot(DocumentSnapshot snapshot) =>
      _$ResponseFromJson(snapshot.data())
          .addDocumentReference(documentReference: snapshot.reference);

  Map<String, dynamic> toJson() => _$ResponseToJson(this);

  @override
  bool operator ==(other) {
    return other.teamMember == teamMember;
  }

  @override
  int get hashCode => ((teamMember ?? "") + (status ?? "")).hashCode;
}
