import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ResponsesClient {
  final String _teamDocID;
  final String _docID;

  ResponsesClient({@required String teamDocID, @required String docID})
      : this._teamDocID = teamDocID,
        this._docID = docID;

  Stream<QuerySnapshot> fetchResponses() {
    return Firestore.instance
        .collection('teams/$_teamDocID/missions/$_docID/responses')
        .snapshots();
  }
}
