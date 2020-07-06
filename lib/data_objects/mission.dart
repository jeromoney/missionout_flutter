import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_annotations/firestore_annotations.dart';

part 'mission.g.dart';

@FirestoreDocument(hasSelfRef: true)
class Mission {
  DocumentReference
      selfRef; // A document reference is created once the mission is uploaded

  String description;
  Timestamp time;
  GeoPoint location;
  String needForAction;
  String locationDescription;
  bool isStoodDown;

  String address() => selfRef
      ?.documentID; // Tried a getter but there is a bug in firestore_annotations that doesn't allow the field to be ignored

  Mission({
    this.selfRef,
    this.description,
    this.time,
    this.location,
    this.needForAction,
    this.locationDescription,
    this.isStoodDown = false,
  });

  Mission.fromApp({
    this.description,
    this.location,
    this.needForAction,
    this.locationDescription,
    this.isStoodDown = false,
  }) : this.time = Timestamp.now(); //some bug in iOS doesn't allow FieldValue.

  /* constructors */
  factory Mission.fromSnapshot(DocumentSnapshot snapshot) =>
      _$missionFromSnapshot(snapshot);

  Map<String, dynamic> toMap() => _$missionToMap(this);

}
