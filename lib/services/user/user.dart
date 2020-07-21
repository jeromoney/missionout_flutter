import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:missionout/data_objects/phone_number_record.dart';


enum PhoneNumberType { mobile, voice }

abstract class User with ChangeNotifier{
  User(
      {@required this.uid,
      this.email,
      this.photoUrl,
      this.displayName,
      @required this.teamID,
      @required this.isEditor,
      this.voicePhoneNumber,
      this.mobilePhoneNumber});

  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;

  // Values held in Firestore
  final String teamID;
  final bool isEditor;
  PhoneNumber voicePhoneNumber;
  PhoneNumber mobilePhoneNumber;

  updatePhoneNumber(
      {@required PhoneNumber phoneNumber, @required PhoneNumberType type});

  updateDisplayName({@required String displayName});

  Future<List<PhoneNumberRecord>> fetchPhoneNumbers();

  Future addPhoneNumber(PhoneNumberRecord phoneNumberRecord);

  Future<List<PhoneNumberRecord>> deletePhoneNumber(PhoneNumberRecord phoneNumberRecord);
}
