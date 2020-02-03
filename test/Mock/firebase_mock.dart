import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class FirebaseAuthMock extends Mock implements FirebaseUser {


  @override
  String get displayName => 'John Doe';
  @override
  String get uid => 'uid';
  @override
  String get email => 'johndoe@mail.com';
  @override
  String get photoUrl => 'https://lh3.googleusercontent.com/a-/AAuE7mByjukLd7ebZ-v9isPAYYiEkrlQmbOqiZeiOLPN=s96-c';
}
