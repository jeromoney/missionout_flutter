import 'package:flutter/material.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:missionout/data_objects/page.dart' as missionpage;
import 'package:provider/provider.dart';

class CreateScreenModel {
  final BuildContext context;
  final Team team;
  final User user;

  CreateScreenModel({@required this.context})
      : this.team = Provider.of<Team>(context),
        this.user = Provider.of<User>(context);

  String get displayName => user.displayName;

  addPage({@required missionpage.Page page}) => team.addPage(page: page);

  addMission({@required Mission mission}) => team.addMission(mission: mission);
}
