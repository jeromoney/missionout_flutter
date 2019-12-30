import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missionout/DataLayer/mission.dart';

class MissionsClient {
  Stream<QuerySnapshot> fetchMissions() {

    final TEAM_ID = 'raux5KIhuIL84bBmPSPs';
    final QUERY_LIMIT = 10;
    return Firestore.instance.collection('teams/$TEAM_ID/missions').orderBy('time',descending: true).limit(QUERY_LIMIT).snapshots();
  }
}
