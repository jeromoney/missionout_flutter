import 'package:cloud_firestore/cloud_firestore.dart';

class ResponsesClient {
  Stream<QuerySnapshot> fetchResponses() {
    final TEAM_ID = 'raux5KIhuIL84bBmPSPs';
    final DOCUMENT_REFERENCE = 'VD2vVykiifgoypT76ifA';

    return Firestore.instance
        .collection('teams/$TEAM_ID/missions')
        .document(DOCUMENT_REFERENCE)
        .collection('responses')
        .snapshots();
  }
}
