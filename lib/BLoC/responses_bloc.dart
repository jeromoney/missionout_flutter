import 'dart:async';

import 'package:mission_out/BLoC/bloc.dart';
import 'package:mission_out/DataLayer/response.dart';
import 'package:mission_out/DataLayer/response_client.dart';

class ResponsesBloc implements Bloc {
  final _client = ResponsesClient();
  final _responsesController = StreamController<List<Response>>();

  Stream<List<Response>> get responsesStream => _responsesController.stream;

  void getResponses() async {
    final responses = await _client.fetchResponses();
    _responsesController.sink.add(responses);
  }

  @override
  void dispose() {
    _responsesController.close();
  }
}
