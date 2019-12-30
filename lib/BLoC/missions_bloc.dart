import 'dart:async';

import 'package:missionout/BLoC/bloc.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/mission_client.dart';

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