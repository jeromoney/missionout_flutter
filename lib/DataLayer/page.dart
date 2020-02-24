import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:missionout/DataLayer/mission.dart';

class Page {
  String creator;
  String description;
  String needForAction;
  String address;
  Mission mission;
  Timestamp time;

  Page({@required this.creator, @required this.mission});

  Map<String, dynamic> toJson() => {
        'creator': creator,
        'description': mission.description,
        'needForAction': mission.needForAction,
        'address': mission.reference.documentID,
        'time': FieldValue.serverTimestamp(),
      };

  Page.fromMap(Map<String, dynamic> map)
      : creator = map['creator'],
        description = map['description'],
        needForAction = map['needForAction'],
        address = map['address'],
        time = map['time'];
}
