import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';

part 'phone_number_record.g.dart';

@immutable
@JsonSerializable()
class PhoneNumberRecord {
  @JsonKey(ignore: true)
  final DocumentReference documentReference;
  final String uid;
  final String isoCode;
  final String phoneNumber;
  final bool allowText;
  final bool allowCalls;

  const PhoneNumberRecord(
      {this.documentReference,
      @required this.uid,
      @required this.isoCode,
      @required this.phoneNumber,
      @required this.allowText,
      @required this.allowCalls});

  // this should be a getter but problems with firestore annotations package
  PhoneNumber getPhoneNumber() =>
      PhoneNumber(isoCode: isoCode, phoneNumber: phoneNumber);

  PhoneNumberRecord addDocumentReference(DocumentReference documentReference) =>
      PhoneNumberRecord(
        documentReference: documentReference,
          uid: uid,
          isoCode: isoCode,
          phoneNumber: phoneNumber,
          allowText: allowText,
          allowCalls: allowCalls);

  /* constructors */
  factory PhoneNumberRecord.fromSnapshot(DocumentSnapshot snapshot) {
    final log = Logger('PhoneNumberRecord');
    try {
      return _$PhoneNumberRecordFromJson(snapshot.data()).copyWith(documentReference: snapshot.reference);
    } on Exception catch (e) {
      log.warning("Phone number in firestore is corrupted", e);
      return null;
    }
  }

  Map<String, dynamic> toMap() => _$PhoneNumberRecordToJson(this);

  PhoneNumberRecord copyWith(
          {DocumentReference documentReference,
          PhoneNumber phoneNumber,
          String uid,
          bool allowText,
          bool allowCalls}) =>
      PhoneNumberRecord(
          documentReference: documentReference ?? this.documentReference,
          uid: uid ?? this.uid,
          isoCode: phoneNumber?.isoCode ?? this.isoCode,
          phoneNumber: phoneNumber?.phoneNumber ?? this.phoneNumber,
          allowText: allowText ?? this.allowText,
          allowCalls: allowCalls ?? this.allowCalls);
}

class PhoneNumber {
  final String isoCode;
  final String phoneNumber;
  PhoneNumber({@required this.isoCode,@required this.phoneNumber});
}
