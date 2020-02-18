import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:missionout/Provider/team.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/CreateScreen/Sections/submit_mission_button.dart';
import 'package:missionout/UI/EditorScreen/editor_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(XXX());

class XXX extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<User>(create: (_) => UserFake()),Provider<Team>(create: (_) => TeamFake())],
      child: MaterialApp(
        home: Scaffold(
          body: EditorScreen(),
        ),
      ),
    );
  }
}

class TeamFake implements Team {
  @override
  String name = 'Parajito Search & Rescue';
  @override
  String teamID;
  @override
  GeoPoint location;
  @override
  String chatURI;

  TeamFake({this.chatURI = 'slack://channel?team=T7XTWLJAH&id=C87SW4NTA'});

  @override
  bool get chatURIisAvailable => true;

  @override
  dynamic get documentAddress {}

  @override
  dynamic toDatabase() {}

  @override
  void updateTeamID(String teamID) {}

  @override
  void launchChat() {
    if (chatURI == 'this will cause an error') {
      throw DiagnosticLevel.error;
    }
  }

  @override
  Future<Function> updateInfo(
      {@required GeoPoint geoPoint, @required String chatUri}) {

  }
}
class UserFake with ChangeNotifier implements User {
  bool signedIn = true;

  UserFake({this.chatURI, this.isEditor = true, this.mobilePhoneNumber = '+3455', this.voicePhoneNumber = '+344'});

  @override
  String chatURI;
  @override
  bool isEditor;
  @override
  String teamID;
  @override
  String voicePhoneNumber;
  @override
  String mobilePhoneNumber;

  @override
  String get displayName => 'John Doe';

  @override
  String get email => 'john@doe.com';

  @override
  String get photoUrl => 'https://images2.minutemediacdn.com/image/upload/c_fit,f_auto,fl_lossy,q_auto,w_728/v1555919852/shape/mentalfloss/magic-eye.jpg';

  @override
  String get uid => '123456';

  @override
  bool get isLoggedIn => true;

  @override
  bool get chatURIisAvailable => true;

  @override
  void signIn() {}

  @override
  void signOut() {
    signedIn = false;
  }

  @override
  void launchChat() {
    if (chatURI == 'this will cause an error') {
      throw DiagnosticLevel.error;
    }
  }

  @override
  void onAuthStateChanged() {}
  @override
  String region;
}