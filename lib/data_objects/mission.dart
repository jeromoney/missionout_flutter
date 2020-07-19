import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:flutter/material.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as timeAgo;

part 'mission.g.dart';

@immutable
@FirestoreDocument(hasSelfRef: true)
class Mission {
  final DocumentReference selfRef;
  final String description;
  final Timestamp time;
  final GeoPoint location;
  final String needForAction;
  final String locationDescription;
  final bool isStoodDown;

  String address() => selfRef
      ?.documentID; // Tried a getter but there is a bug in firestore_annotations that doesn't allow the field to be ignored

  String timeSincePresent() =>
      timeAgo.format(time.toDate(), locale: "en_long");

  const Mission({
    this.selfRef,
    this.description,
    this.time,
    this.location,
    this.needForAction,
    this.locationDescription,
    this.isStoodDown = false,
  });

  const Mission.fromApp({
    @required this.description,
    this.location,
    this.needForAction,
    this.locationDescription,
    this.isStoodDown = false,
  })  : this.time = null,
        this.selfRef = null;

  Mission clone({
    DocumentReference selfRef,
    String description,
    GeoPoint location,
    String needForAction,
    String locationDescription,
    bool isStoodDown,
  }) =>
      Mission(
        selfRef: selfRef ?? this.selfRef,
        description: description ?? this.description,
        time: this.time,
        location: location ?? this.location,
        needForAction: needForAction ?? this.needForAction,
        locationDescription: locationDescription ?? this.locationDescription,
        isStoodDown: isStoodDown ?? this.isStoodDown,
      );

  /* constructors */
  factory Mission.fromSnapshot(DocumentSnapshot snapshot) =>
      _$missionFromSnapshot(snapshot);

  //Firestore Annotations can not handle Field Value at the moment
  Map<String, dynamic> toMap() =>
      _$missionToMap(this)..["time"] = FieldValue.serverTimestamp();
}
