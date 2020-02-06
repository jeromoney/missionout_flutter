import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/Provider/firestore_service.dart';
import 'package:mockito/mockito.dart';

class FirebaseAuthMock extends Mock implements FirebaseUser {
  @override
  String get displayName => 'John Doe';

  @override
  String get uid => 'uid';

  @override
  String get email => 'johndoe@mail.com';

  @override
  String get photoUrl =>
      'https://lh3.googleusercontent.com/a-/AAuE7mByjukLd7ebZ-v9isPAYYiEkrlQmbOqiZeiOLPN=s96-c';
}

class FirestoreServiceMock extends Mock implements FirestoreService {
  @override
  Stream<Mission> fetchSingleMission(
      {@required String teamID,@required String docID}) {
    return missionStreamGenerator();
  }

  Stream<Mission> missionStreamGenerator() async*{
    await Future.delayed(Duration(milliseconds: 20));
    yield Mission('hello','world','somewhere',null);
  }


}
