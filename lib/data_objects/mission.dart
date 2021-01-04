import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as timeAgo;

import 'json_converters.dart';

part 'mission.g.dart';

@immutable
@JsonSerializable()
class Mission {
  @JsonKey(ignore: true)
  final DocumentReference documentReference;
  final String description;
  @TimestampJsonConverter()
  final Timestamp time;
  @GeoPointJsonConverter()
  final GeoPoint location;
  final String needForAction;
  final String locationDescription;
  final bool isStoodDown;

  String get address => documentReference?.id;

  String timeSincePresent() => timeAgo.format(time.toDate(), locale: "en_long");

  const Mission({
    this.documentReference,
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
        this.documentReference = null;

  Mission copyWith({
    DocumentReference documentReference,
    String description,
    GeoPoint location,
    String needForAction,
    String locationDescription,
    bool isStoodDown,
  }) =>
      Mission(
        documentReference: documentReference ?? this.documentReference,
        description: description ?? this.description,
        time: this.time,
        location: location ?? this.location,
        needForAction: needForAction ?? this.needForAction,
        locationDescription: locationDescription ?? this.locationDescription,
        isStoodDown: isStoodDown ?? this.isStoodDown,
      );

  /* constructors */
  factory Mission.fromSnapshot(DocumentSnapshot snapshot) =>
      _$MissionFromJson(snapshot.data()).copyWith(documentReference: snapshot.reference);

  //Firestore Annotations can not handle Field Value at the moment
  Map<String, dynamic> toMap() =>
      _$MissionToJson(this)..["time"] = FieldValue.serverTimestamp();
}
