import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';


enum PhoneNumberType { mobile, voice }

abstract class User {
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
}