import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Page {
  final String _description;
  final String _action;
  Timestamp time;

  Page({@required String description, @required String action})
      : this._description = description,
        this._action = action;

  Map<String, dynamic> toJson() => {
        'description': _description,
        'action': _action,
        'time': FieldValue.serverTimestamp(),
      };
}
