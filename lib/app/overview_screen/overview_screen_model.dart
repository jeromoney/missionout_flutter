import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/app/create_screen/create_screen.dart';
import 'package:missionout/app/detail_screen/detail_screen.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/mission_address_arguments.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

class OverviewScreenModel {
  final BuildContext context;
  final Team team;
  final User user;

  OverviewScreenModel(this.context)
      : this.team = context.watch<Team>(),
        this.user = context.watch<User>();

  bool get isEditor => user?.isEditor;

  Stream<List<Mission>> fetchMissions() => team.fetchMissions();

  navigateToDetail(
      {@required Mission mission,
      @required DocumentReference documentReference}) {
    final MissionAddressArguments arguments =
        MissionAddressArguments(mission.selfRef);
    Navigator.pushNamed(context, DetailScreen.routeName, arguments: arguments);
  }

  navigateToCreate() => Navigator.of(context).push(CreatePopupRoute());
}
