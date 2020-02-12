import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/DetailScreen/Sections/actions_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';


class XXX extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final mission = Mission('A lost puppy', 'Need snow mobilers', 'Squaw Creek',
        GeoPoint(2.3, 22.3));


    return MultiProvider(
      providers: [
      Provider<UserMock>(create: (_) => UserMock()),

      ],
      child: MaterialApp(
        home: Scaffold(
          body: ActionsDetailScreen(
            snapshot: AsyncSnapshot.withError(ConnectionState.done, Error()),
          ),
        ),
      ),
    );
  }
}


void main() => runApp(XXX());


class UserMock  {
  final String chatURI;
  final missionID = '123456';
  final teamID = 'something';
  @override
  bool isEditor;

  UserMock({this.isEditor = true, this.chatURI = 'helooworld'});

  bool get chatURIisAvailable => true;

  launchChat() {
    if (chatURI.contains('error')) {
      throw DiagnosticLevel.error;
    }
  }

  @override
  String voicePhoneNumber;
  @override
  String mobilePhoneNumber;

  @override
  String get displayName => 'john mayer';

  @override
  String get email => 'john@doe.com';

  @override
  String get photoUrl => 'http://www.something.com/picture.jpg';

  @override
  String get uid => '12354';

  @override
  bool get isLoggedIn => true;

  @override
  void signIn() {}

  @override
  void signOut() {}

  @override
  void onAuthStateChanged() {}
}
