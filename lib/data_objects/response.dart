import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:missionout/data_objects/JsonConverters.dart';

part 'response.g.dart';

@immutable
@JsonSerializable()
class Response {
  @JsonKey(ignore: true)
  static const RESPONSES = ['Responding', 'Delayed', 'Standby', 'Unavailable'];
  @DocumentReferenceJsonConverter()
  final DocumentReference selfRef;
  final String teamMember;
  final String status;
  @TimestampJsonConverter()
  final Timestamp time;

  Response(
      {@required this.teamMember,
      @required this.status,
      this.selfRef,
      this.time,
      hashCode}); // Hacky- there is a bug in the firestore_annotations where hashCode is not being ignored. This allows the generated code to work

  Response.fromApp({@required this.teamMember, @required this.status})
      : time = Timestamp.now(),
        this.selfRef = null;

  factory Response.fromSnapshot(DocumentSnapshot snapshot) =>
      _$ResponseFromJson(snapshot.data());

  Map<String, dynamic> toJson() => _$ResponseToJson(this);

  @override
  bool operator ==(other) {
    return other.teamMember == teamMember;
  }

  @override
  int get hashCode => ((teamMember ?? "") + (status ?? "")).hashCode;
}
