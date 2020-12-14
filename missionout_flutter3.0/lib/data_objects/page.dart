import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:missionout/data_objects/JsonConverters.dart';
import 'package:missionout/data_objects/mission.dart';

part 'page.g.dart';

@immutable
@JsonSerializable()
class Page {
  final String creator;
  final String description;
  final String needForAction;
  final String address;
  final bool onlyEditors; // Page is restricted to Editors only
  @TimestampJsonConverter()
  final Timestamp time;

  Page({
    this.creator,
    this.description,
    this.needForAction,
    this.address,
    this.onlyEditors,
    this.time,
  });

  Page.fromMission(
      {@required this.creator,
      @required Mission mission,
      this.onlyEditors = false})
      : description = mission.description,
        needForAction = mission.needForAction,
        address = mission.address,
        time = Timestamp.now();

  Map<String, dynamic> toJson() =>
      _$PageToJson(this); //some bug in iOS doesn't allow FieldValue
}
