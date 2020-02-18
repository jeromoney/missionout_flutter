import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/Provider/team.dart';
enum Yield { error, zeroResults, results, waiting }

class TeamFake implements Team{
  Yield yieldValue;

  TeamFake({this.yieldValue = Yield.results,this.chatURI = 'https://something.com'});

  @override
  String name;
  @override
  String teamID;
  @override
  GeoPoint location;
  @override
  String chatURI;


  @override
  bool get chatURIisAvailable => true;

  @override
  dynamic get documentAddress {

  }

  @override
  dynamic toDatabase() {

  }

  @override
  void updateTeamID(String teamID) {

  }

  @override
  void launchChat() {
    if (chatURI == 'this will cause an error') {throw DiagnosticLevel.error;}
  }

  @override
  Future<Function> updateInfo(
      {@required GeoPoint geoPoint, @required String chatUri}) {
  }

  @override
  Future<DocumentReference> addMission({String teamId, Mission mission}) async {
    switch (yieldValue) {
      case Yield.results:
        {
          return Firestore.instance.document('');
        }
        break;

      case Yield.error:
        {
          return null;
        }
        break;

      case Yield.zeroResults:
        {
          return null;
        }
        break;

      default:
        {
          ;
        }
        break;
    }
  }

  @override
  Future<void> addPage({String teamID, String missionDocID, Page page}) {
    return null;
  }

  @override
  Future<void> addResponse(
      {Response response, String teamID, String docID, String uid}) {
    return null;
  }

  @override
  Stream<List<Mission>> fetchMissions() async* {
    await Future.delayed(Duration(milliseconds: 100));
    switch (yieldValue) {
      case Yield.results:
        {
          yield [Mission('dfdf', 'dfdf', 'dfdf', null)];
        }
        break;

      case Yield.error:
        {
          yield null;
        }
        break;

      case Yield.zeroResults:
        {
          yield [];
        }
        break;

      default:
        {
          ;
        }
        break;
    }
  }

  @override
  Stream<List<Response>> fetchResponses({String docID}) async* {
    await Future.delayed(Duration(milliseconds: 100));
    switch (yieldValue) {
      case Yield.waiting:
        {
          await Future.delayed(Duration(seconds: 1));
        }
        break;

      case Yield.results:
        {
          yield [Response(status: 'late',teamMember: 'john doe')];
        }
        break;

      case Yield.error:
        {
          yield null;
        }
        break;

      case Yield.zeroResults:
        {
          yield [];
        }
        break;

      default:
        {
          ;
        }
        break;
    }
  }

  @override
  Stream<Mission> fetchSingleMission({String teamID, String docID}) {
    return null;
  }

  @override
  Future<void> updatePhoneNumbers(
      {String uid, String mobilePhoneNumber, String voicePhoneNumber}) {
    // TODO: implement updatePhoneNumbers
  }

  @override
  void standDownMission({Mission mission, String teamID}) {
    return;
  }
}