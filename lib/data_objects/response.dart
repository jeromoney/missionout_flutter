
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class Response {
  @JsonKey(required: true)
  final String teamMember;
  @JsonKey(required: true)
  String status;
  @JsonKey(ignore: true)
  Timestamp time;

  Response({@required String teamMember, @required String status})
      : this.teamMember = teamMember,
        this.status = status;

  factory Response.fromSnapshot(DocumentSnapshot snapshot) => _$ResponseFromJson(snapshot.data);

  Map<String, dynamic> toJson() => _$ResponseToJson(this)..['time'] = Timestamp.now(); //TODO - some bug in iOS doesn't allow FieldValue
  
  @override
  bool operator ==(other) {
    return other.teamMember == teamMember;
  }

  @override
  int get hashCode => ((teamMember ?? "") + (status ?? "")).hashCode;
}
