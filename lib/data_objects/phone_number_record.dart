import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:logging/logging.dart';

part 'phone_number_record.g.dart';

@immutable
@FirestoreDocument(hasSelfRef: true)
class PhoneNumberRecord {
  final DocumentReference selfRef;
  final String uid;
  final String isoCode;
  final String phoneNumber;
  final bool allowText;
  final bool allowCalls;

  const PhoneNumberRecord(
      {this.selfRef,
      @required this.uid,
      @required this.isoCode,
      @required this.phoneNumber,
      @required this.allowText,
      @required this.allowCalls});

  // this should be a getter but problems with firestore annotations package
  PhoneNumber getPhoneNumber() => PhoneNumber(isoCode: isoCode, phoneNumber: phoneNumber);

  /* constructors */
  factory PhoneNumberRecord.fromSnapshot(DocumentSnapshot snapshot) {
    final log = Logger('PhoneNumberRecord');
    try {
      return _$phoneNumberRecordFromSnapshot(snapshot);
    } on Exception catch (e) {
      log.warning("Phone number in firestore is corrupted", e);
      return null;
    }
  }

  Map<String, dynamic> toMap() => _$phoneNumberRecordToMap(this);

  PhoneNumberRecord copyWith(
          {DocumentReference selfRef,
          PhoneNumber phoneNumber,
          String uid,
          bool allowText,
          bool allowCalls}) =>
      PhoneNumberRecord(
          selfRef: selfRef ?? this.selfRef,
          uid: uid ?? this.uid,
          isoCode: phoneNumber?.isoCode ?? this.isoCode,
          phoneNumber: phoneNumber?.phoneNumber ?? this.phoneNumber,
          allowText: allowText ?? this.allowText,
          allowCalls: allowCalls ?? this.allowCalls);
}
