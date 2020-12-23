import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:missionout/data_objects/JsonConverters.dart';
import 'package:missionout/data_objects/mission.dart';

part 'page.g.dart';

@immutable
@JsonSerializable()
class Page {
  @JsonKey(ignore: true)
  final Mission mission;
  final String creator;
  final bool onlyEditors; // Is Page restricted to Editors only
  @TimestampJsonConverter()
  final Timestamp time;

  String get description => mission.description;
  set description(String doNotUse) {throw UnimplementedError("Setter is only used for JSON serialization");}
  String get needForAction => mission.needForAction;
  set needForAction(String doNotUse) {throw UnimplementedError("Setter is only used for JSON serialization");}
  String get missionDocumentPath => mission.documentReference.path;
  set missionDocumentPath(String doNotUse) {throw UnimplementedError("Setter is only used for JSON serialization");}

  Page({
    this.mission,
    this.creator,
    this.onlyEditors,
    this.time,
  });

  Page.fromMission(
      {@required this.creator,
      @required this.mission,
      this.onlyEditors = false})
      : time = Timestamp.now();

  Map<String, dynamic> toJson() =>
      _$PageToJson(this); //some bug in iOS doesn't allow FieldValue
}
