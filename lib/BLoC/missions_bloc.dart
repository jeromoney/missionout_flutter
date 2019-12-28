import 'dart:async';

import 'package:mission_out/BLoC/bloc.dart';
import 'package:mission_out/DataLayer/mission.dart';
import 'package:mission_out/DataLayer/mission_client.dart';

class MissionsBloc implements Bloc{
  final _client = MissionsClient();
  final _missionsController = StreamController<List<Mission>>();

  Stream<List<Mission>> get missionsStream => _missionsController.stream;

  void getMissions() async{
     final missions = await _client.fetchMissions();
    _missionsController.sink.add(missions);
  }


  @override
  void dispose() {
    _missionsController.close();
  }}