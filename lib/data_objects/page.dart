import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:flutter/foundation.dart';
import 'package:missionout/data_objects/mission.dart';

part 'page.g.dart';

@FirestoreDocument(hasSelfRef: false)
class Page {
  final String creator;
  final String description;
  final String needForAction;
  final String address;
  final bool onlyEditors; // Page is restricted to Editors only

  Page({this.creator, this.description, this.needForAction, this.address, this.onlyEditors});

  Page.fromMission(
      {@required this.creator,
      @required Mission mission,
      this.onlyEditors = false})
      : description = mission.description,
        needForAction = mission.needForAction,
        address = mission.address();

  Map<String, dynamic> toJson() => _$pageToMap(this); //some bug in iOS doesn't allow FieldValue
}
