import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampJsonConverter implements JsonConverter<Timestamp, Timestamp> {
  const TimestampJsonConverter();

  @override
  Timestamp fromJson(Timestamp value) => value;

  @override
  Timestamp toJson(Timestamp value) => value;
}

class DocumentReferenceJsonConverter implements JsonConverter<DocumentReference, DocumentReference> {
  const DocumentReferenceJsonConverter();

  @override
  DocumentReference fromJson(DocumentReference value) => value;

  @override
  DocumentReference toJson(DocumentReference value) => value;
}

class GeoPointJsonConverter implements JsonConverter<GeoPoint, GeoPoint> {
  const GeoPointJsonConverter();

  @override
  GeoPoint fromJson(GeoPoint value) => value;

  @override
  GeoPoint toJson(GeoPoint value) => value;
}