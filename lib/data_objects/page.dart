import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:missionout/data_objects/mission.dart';
class Page {
  String creator;
  String description;
  String needForAction;
  String address;
  Mission mission;
  Timestamp time;
  bool onlyEditors;

  Page({@required this.creator, @required this.mission, this.onlyEditors = false});

  Map<String, dynamic> toJson() => {
        'creator': creator,
        'description': mission.description,
        'needForAction': mission.needForAction,
        'address': mission.reference.documentID,
        'time': Timestamp.now(), //TODO - some bug in iOS doesn't allow FieldValue. Remove null when this is fixed
        'onlyEditors': onlyEditors,
      };
}
