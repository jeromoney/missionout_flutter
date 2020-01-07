import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:missionout/DataLayer/response.dart';

class SingleMissionClient {
  final String _teamID;
  final String _docID;
  final String _uid;

  SingleMissionClient(
      {@required String teamDocID,
      @required String docID,
      @required String uid})
      : _teamID = teamDocID,
        _docID = docID,
        _uid = uid;

  Stream<DocumentSnapshot> fetchSingleMission() {
    return Firestore.instance
        .document('teams/$_teamID/missions/$_docID')
        .snapshots();
  }

  Future<void> addResponse({@required Response response}) async {
    DocumentReference document = Firestore.instance
        .collection('teams/$_teamID/missions/$_docID/responses')
        .document(_uid);
    if (response != null) {
      await document.setData(response.toJson());
    } else {
      await document.delete();
    }
  }

  void addPage(Page page) {
    Firestore.instance.collection('teams/$_teamID/missions/$_docID/alarms').add(page.toJson());
  }

  void standDown({@required bool standDown}) {
    Firestore.instance
        .document('teams/$_teamID/missions/$_docID').updateData({'stoodDown':standDown});
  }
}
