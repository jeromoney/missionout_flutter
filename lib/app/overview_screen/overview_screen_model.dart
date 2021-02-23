import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/app/create_screen/create_screen.dart';
import 'package:missionout/app/detail_screen/detail_screen.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/mission_address_arguments.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

class OverviewScreenModel {
  final BuildContext context;
  final Team team;
  final User user;

  OverviewScreenModel(this.context)
      : team = context.watch<Team>(),
        user = context.watch<User>();

  bool get isEditor => user?.isEditor;

  Stream<List<Mission>> fetchMissions() => team.fetchMissions();

  void navigateToDetail({@required Mission mission}) {
    final MissionAddressArguments arguments =
        MissionAddressArguments(mission.documentReference);
    Navigator.pushNamed(context, DetailScreen.routeName, arguments: arguments);
  }

  Future navigateToCreate() => Navigator.of(context).push(CreatePopupRoute());

  static Future clearBadges() async {
    Pushy.clearBadge();
  }
}

Future directDetailScreenNavigation(
    {@required BuildContext context, @required String path}) async {
  final team = context.watch<Team>();
  final DocumentReference documentReference =
      await team.getDocumentReference(path);
  final MissionAddressArguments arguments =
      MissionAddressArguments(documentReference);
  Navigator.pushNamed(context, DetailScreen.routeName, arguments: arguments);
}
