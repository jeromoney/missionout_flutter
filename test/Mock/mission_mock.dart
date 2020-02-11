import 'package:missionout/DataLayer/mission.dart';
import 'package:mockito/mockito.dart';

class MissionMock extends Mock implements Mission{
  get address => '12345 Main St';
}