import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missionout/BLoC/bloc.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/DataLayer/response_client.dart';

class ResponsesBloc implements Bloc {
  final _client = ResponsesClient();

  Stream<QuerySnapshot> get responsesStream => _client.fetchResponses();

  @override
  void dispose() {
  }
}
