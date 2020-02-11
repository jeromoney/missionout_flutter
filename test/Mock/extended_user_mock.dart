import 'package:flutter/foundation.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:mockito/mockito.dart';

class ExtendedUserMock extends Mock implements ExtendedUser {
  final String chatURI;
  final isEditor;
  final missionID = '123456';
  final teamID = 'something';

  ExtendedUserMock({this.isEditor = true, this.chatURI});



  bool chatURIisAvailable() => true;

  launchChat() {
    if (chatURI.contains('error')) {
      throw DiagnosticLevel.error;
    }
  }
}
