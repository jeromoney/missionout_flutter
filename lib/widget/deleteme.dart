import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/DataLayer/mission.dart';
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
        Provider<ExtendedUser>(
            create: (_) => ExtendedUserMock(chatURI: 'fdgdgd'))
      ],
      child: MaterialApp(
        home: Scaffold(
          body: ActionsDetailScreen(
            snapshot: AsyncSnapshot.withData(ConnectionState.done, mission),
          ),
        ),
      ),
    );
  }
}
class ExtendedUserMock extends Mock implements ExtendedUser{
  final String chatURI;

  ExtendedUserMock({this.chatURI});

  bool chatURIisAvailable() => true;

  launchChat(){}
}

void main() => runApp(XXX());