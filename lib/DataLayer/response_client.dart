import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ResponsesClient {
  Stream<QuerySnapshot> fetchResponses(
      {@required String teamDocID, @required String docID}) {
    return Firestore.instance
        .collection('teams/$teamDocID/missions/$docID/responses')
        .snapshots();
  }
}
