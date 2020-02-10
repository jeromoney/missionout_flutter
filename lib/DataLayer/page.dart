import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:missionout/DataLayer/mission.dart';

class Page {
  final Mission _mission;
  Timestamp time;

  Page({@required Mission mission})
      : _mission = mission;

  Map<String, dynamic> toJson() => {
        'description': _mission.description,
        'action': _mission.needForAction,
        'time': FieldValue.serverTimestamp(),
      };
}
