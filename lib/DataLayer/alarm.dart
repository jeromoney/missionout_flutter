import 'package:cloud_firestore/cloud_firestore.dart';

class Alarm {
  final String description;
  final String action;
  Timestamp time;

  Alarm(this.description, this.action);

  Map<String, dynamic> toJson() => {
        'description': description,
        'action': action,
        'time': FieldValue.serverTimestamp(),
      };
}
