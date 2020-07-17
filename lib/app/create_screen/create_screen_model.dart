import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/app/detail_screen/detail_screen.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/mission_address_arguments.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:missionout/data_objects/page.dart' as missionpage;
import 'package:provider/provider.dart';


class CreateScreenModel {
  final BuildContext context;
  final Team _team;
  final User _user;
  final DocumentReference _documentReference;

  CreateScreenModel({@required this.context})
      : this._team = context.watch<Team>(),
        this._user = context.watch<User>(),
        this._documentReference = context.watch<DocumentReference>();

  String get displayName => _user.displayName;

  bool get isEditExistingMission => _documentReference != null;

  addPage({@required missionpage.Page page}) => _team.addPage(page: page);

  editMission({@required Mission mission}) async {
    final reference = await _team.addMission(mission: mission);
    final MissionAddressArguments arguments =
        MissionAddressArguments(reference);
    Navigator.pushNamed(context, DetailScreen.routeName, arguments: arguments);
  }

  Future addMission({@required Mission mission}) async {
    final DocumentReference reference =
        await _team.addMission(mission: mission);
    if (reference == null) {
      // there was an error adding mission to database
      throw HttpException("Error adding mission to database");
    }
    final referencedMission = mission.clone(selfRef: reference);

    // send page to editors only
    final page = missionpage.Page.fromMission(
        creator: displayName ?? "unknown user",
        mission: referencedMission,
        onlyEditors: true);
    _team.addPage(page: page);
    final MissionAddressArguments arguments =
        MissionAddressArguments(reference);
    Navigator.pushNamed(context, DetailScreen.routeName, arguments: arguments);
  }

  Future<Mission> getCurrentMission() async {
    return await _team
        .fetchSingleMission(documentReference: _documentReference)
        .first;
  }
}
