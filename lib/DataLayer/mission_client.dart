import 'package:cloud_firestore/cloud_firestore.dart';

class MissionsClient {
  Stream<QuerySnapshot> fetchMissions(String teamId) {
    const QUERY_LIMIT = 10;
    return Firestore.instance.collection('teams/$teamId/missions').orderBy('time',descending: true).limit(QUERY_LIMIT).snapshots();
  }

  Stream<DocumentSnapshot> fetchSingleMissions({String teamId, String docId}) {
    return Firestore.instance.document('teams/$teamId/missions/$docId').snapshots();
  }
}
