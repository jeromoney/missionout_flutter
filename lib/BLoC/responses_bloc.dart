import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:missionout/BLoC/bloc.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/DataLayer/response_client.dart';

class ResponsesBloc implements Bloc {
  final _client = ResponsesClient();
  final String _teamDocID;
  final String _docID;

  final _responsesController = StreamController<List<Response>>();

  ResponsesBloc({@required String teamDocID, @required String docID})
      : this._teamDocID = teamDocID,
        this._docID = docID;

  Stream<QuerySnapshot> get responsesStream =>
      _client.fetchResponses(teamDocID: _teamDocID, docID: _docID);


  @override
  void dispose() {
    _responsesController.close();
  }
}
