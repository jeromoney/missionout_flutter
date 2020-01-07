import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:missionout/BLoC/bloc.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/DataLayer/response_client.dart';

class ResponsesBloc implements Bloc {
  ResponsesBloc({@required String teamDocID, @required String docID})
      : this._client = ResponsesClient(teamDocID: teamDocID, docID: docID);
  final _client;

  Stream<List<Response>> get stream {
    Stream<QuerySnapshot> _clientStream = _client.fetchResponses();
    return _clientStream.map((querySnapshot) {
      List<Response> responses = querySnapshot.documents
          .map((snapshot) => Response.fromSnapshot(snapshot))
          .toList();
      return responses;
    });
  }

  @override
  void dispose() {
    stream.drain();
  }
}
