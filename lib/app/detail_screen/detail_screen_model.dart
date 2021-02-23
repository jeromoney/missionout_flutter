import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:missionout/app/create_screen/create_screen.dart';
import 'package:missionout/core/location.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/mission_address_arguments.dart';
import 'package:missionout/data_objects/page.dart' as missionpage;
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreenModel {
  final BuildContext context;
  final Team team;
  final DocumentReference documentReference;
  final User user;
  final StreamController<bool> sheetStreamController;

  DetailScreenModel(this.context)
      : team = context.watch<Team>(),
        user = context.watch<User>(),
        documentReference = (ModalRoute.of(context).settings.arguments
                as MissionAddressArguments)
            .documentReference,
        sheetStreamController = context.watch<StreamController<bool>>();

  Stream<LatLng> get missionLocation {
    final mission =
        team.fetchSingleMission(documentReference: documentReference);
    return mission.map((mission) {
      final location = mission.location;
      if (location == null) return null;
      return LatLng(location.latitude, location.longitude);
    });
  }

  Stream<Mission> fetchSingleMission() =>
      team.fetchSingleMission(documentReference: documentReference);

  void displayResponseSheet() => sheetStreamController.add(true);

  void hideResponseSheet() => sheetStreamController.add(false);

  void launchChat() {
    try {
      team.launchChat();
    } catch (e) {
      Scaffold.of(context).showSnackBar(const SnackBar(
        content: Text('Error: Is Slack installed?'),
      ));
    }
  }

  void launchMap(Mission mission) {
    final geoPoint = mission.location;
    final lat = geoPoint.latitude;
    final lon = geoPoint.longitude;
    // launches location in external map application.
    // currently optimized for gmaps. The location is opened
    // as a query "?q=" so the label is displayed.
    String url;
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.android) {
      url = 'geo:0,0?q=$lat,$lon';
    } else if (platform == TargetPlatform.iOS) {
      // TODO - open in caltopo, etc instead of just apple maps
      url = 'http://maps.apple.com/?q=$lat,$lon';
    }
    else {
      url = "https://www.google.com/maps";
    }
    launch(url);
  }

  bool get chatURIAvailable => team.chatURI != null;

  String get email => user.email;

  String get displayName => user.displayName;

  bool get isEditor => user.isEditor;

  void addResponse({@required Response response}) => team.addResponse(
      response: response, docID: documentReference.id, uid: user.uid);

  void addPage({@required missionpage.Page page}) => team.addPage(page: page);

  void standDownMission({@required Mission mission}) =>
      team.standDownMission(mission: mission);

  void navigateToCreateScreen() {
    assert(documentReference != null);
    Navigator.of(context).pushReplacement(
      CreatePopupRoute(documentReference: documentReference),
    );
  }

  void navigateToOverviewScreen() => Navigator.of(context).pop();

  Future<int> getCurrentlySelectedResponse() async {
    final response = await team.fetchUserResponse(
        documentReference: documentReference, uid: user.uid);
    if (response == null) return -1;
    return Response.RESPONSES.indexOf(response.status);
  }
}
