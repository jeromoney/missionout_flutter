import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/Provider/team.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/CreateScreen/Sections/submit_mission_button.dart';
import 'package:missionout/UI/EditorScreen/Sections/team_submit_raised_button.dart';
import 'package:missionout/UI/EditorScreen/editor_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(XXX());

class XXX extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(
          create: (_) => UserFake(),
        ),
        Provider<Team>(
          create: (_) => TeamFake(),
        ),
      ],
      child: MaterialApp(
          home: Scaffold(
              body: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          child: TeamSubmitRaisedButton(
                            formKey: formKey,
                            chatURIController: TextEditingController(),
                            lonController: TextEditingController(),
                            latController: TextEditingController(),
                          )),
                      TextFormField(
                        validator: (value) => null,
                      )
                    ],
                  )))),
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

  @override
  Future<DocumentReference> addMission({@required Mission mission}) {

  }

  @override
  Stream<List<Mission>> fetchMissions() {

  }

  @override
  Future<Function> addResponse(
      {@required Response response, @required String docID, @required String uid}) {

  }

  @override
  Future<Function> addPage({@required Page page}) {

  }

  @override
  void standDownMission({@required Mission mission}) {

  }

  @override
  Stream<List<Response>> fetchResponses({@required String docID}) {

  }

  @override
  Stream<Mission> fetchSingleMission({@required String docID}) {

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

  @override
  Future<Function> updatePhoneNumbers(
      {@required String mobilePhoneNumber, @required String voicePhoneNumber}) {

  }
}