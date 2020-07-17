import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:missionout/data_objects/page.dart' as missionpage;
import 'package:provider/provider.dart';

import '../auth_widget_builder.dart';

class CreateScreenModel {
  final BuildContext context;
  final Team _team;
  final User _user;
  final DocumentReference _documentReference;

  CreateScreenModel({@required this.context})
      : this._team = Provider.of<Team>(context),
        this._user = Provider.of<User>(context),
        this._documentReference = Provider.of<DocumentReference>(context);

  String get displayName => _user.displayName;

  bool get isEditExistingMission => _documentReference != null;

  addPage({@required missionpage.Page page}) => _team.addPage(page: page);

  editMission({@required Mission mission}) async {
    final reference = await _team.addMission(mission: mission);
    Provider.of<DocumentReferenceHolder>(context).documentReference =
        reference;
  }

  Future addMission({@required Mission mission}) async {
    final DocumentReference reference =
        await _team.addMission(mission: mission);
    if (reference == null) {
      // there was an error adding mission to database
      throw HttpException("Error adding mission to database");
    }
    Provider.of<DocumentReferenceHolder>(context).documentReference = reference;
    final referencedMission = mission.clone(selfRef: reference);

    // send page to editors only
    final page = missionpage.Page.fromMission(
        creator: displayName ?? "unknown user",
        mission: referencedMission,
        onlyEditors: true);
    _team.addPage(page: page);
  }

  Future<Mission> getCurrentMission() async {
    return await _team.fetchSingleMission(documentReference: _documentReference).first;
  }
}
