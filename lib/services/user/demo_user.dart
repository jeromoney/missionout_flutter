import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:missionout/services/user/user.dart';

class DemoUser implements User {


  @override
  bool isEditor = true;

  @override
  PhoneNumber mobilePhoneNumber = PhoneNumber(phoneNumber: "+12125551234",isoCode: "US");

  @override
  String region = "US";

  @override
  String teamID = "demo_team.com";

  @override
  PhoneNumber voicePhoneNumber = PhoneNumber(phoneNumber: "+12125554321",isoCode: "US");



  @override
  // TODO: implement uid
  String get uid => null;

  @override
  Future updatePhoneNumbers(
      {PhoneNumber mobilePhoneNumberVal, PhoneNumber voicePhoneNumberVal}) {
    mobilePhoneNumber = mobilePhoneNumberVal;
    voicePhoneNumber = voicePhoneNumberVal;
  }

  @override
  String currentMission;

  @override
  // TODO: implement displayName
  String get displayName => throw UnimplementedError();

  @override
  // TODO: implement email
  String get email => throw UnimplementedError();

  @override
  // TODO: implement photoUrl
  String get photoUrl => throw UnimplementedError();

  @override
  updatePhoneNumber({PhoneNumber phoneNumber, PhoneNumberType type}) {
    // TODO: implement updatePhoneNumber
    throw UnimplementedError();
  }

  @override
  updateDisplayName({String displayName}) {
    // TODO: implement updateDisplayName
    throw UnimplementedError();
  }
}
