import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:missionout/data_objects/phone_number_record.dart';

enum PhoneType { mobile, voice }

abstract class User with ChangeNotifier {
  User(
      {@required this.uid,
      this.email,
      this.photoUrl,
      this.displayName,
      @required this.teamID,
      @required this.isEditor,});
  BuildContext context;


  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;

  // Values held in Firestore
  final String teamID;
  final bool isEditor;
  bool enableIOSCriticalAlerts;
  double iOSCriticalAlertsVolume;
  String iOSSound;

  void updatePhoneNumber(
      {@required PhoneNumber phoneNumber, @required PhoneType type});

  void updateDisplayName({@required String displayName});

  Stream<List<PhoneNumberRecord>> fetchPhoneNumbers();

  Future addPhoneNumber(PhoneNumberRecord phoneNumberRecord);

  Future deletePhoneNumber(PhoneNumberRecord phoneNumberRecord);
}
