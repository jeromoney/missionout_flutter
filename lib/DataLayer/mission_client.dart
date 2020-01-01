import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missionout/DataLayer/mission.dart';

class MissionsClient {
  Stream<QuerySnapshot> fetchMissions(String team_id) {
    final QUERY_LIMIT = 10;
    return Firestore.instance.collection('teams/$team_id/missions').orderBy('time',descending: true).limit(QUERY_LIMIT).snapshots();
  }
}
