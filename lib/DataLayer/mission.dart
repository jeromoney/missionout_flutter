import 'package:cloud_firestore/cloud_firestore.dart';

class Mission {
  String description;
  Timestamp time;
  GeoPoint location;
  String needForAction;
  String locationDescription;
  bool isStoodDown;
  DocumentReference
      reference; // A document reference is created once the mission is uploaded

  Mission(description, needForAction, locationDescription, geoPoint)
      : this.description = description,
        this.time = null,
        this.location = geoPoint,
        this.needForAction = needForAction,
        this.locationDescription = locationDescription,
        this.isStoodDown = false,
        this.reference = null;

  Mission.fromMap(Map<String, dynamic> map, {this.reference})
      : description = map['description'],
        time = map['time'],
        location = map['location'],
        needForAction = map['needForAction'],
        locationDescription = map['locationDescription'],
        isStoodDown = map['stoodDown']??false;

  Mission.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toJson() => {
        'description': description,
        'location': location,
        'needForAction': needForAction,
        'locationDescription': locationDescription,
        'stoodDown': isStoodDown,
        'time': FieldValue.serverTimestamp(),
      };
}
