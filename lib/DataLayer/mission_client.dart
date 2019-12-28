import 'package:mission_out/DataLayer/mission.dart';

class MissionsClient {
  Future<List<Mission>> fetchMissions() async {
    final mission0 = Mission('Lost hikers', 'need ground team', 'mt yale');
    final mission1 =
        Mission('Lost snowmobilers', 'need snowmobile team', 'cottonwood pass');
    final missions = [mission0, mission1, mission0, mission1,mission0, mission1, mission0, mission1];
    return missions;
  }
}
