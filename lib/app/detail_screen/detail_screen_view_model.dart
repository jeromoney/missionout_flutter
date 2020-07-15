import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:missionout/data_objects/page.dart' as missionpage;
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/mission_address_arguments.dart';
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/services/response_sheet_controller.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreenViewModel {
  final BuildContext context;
  final Team team;
  final String docId;
  final User user;

  DetailScreenViewModel({@required this.context})
      : this.team = Provider.of<Team>(context),
        this.user = Provider.of<User>(context),
        this.docId = (ModalRoute.of(context).settings.arguments
                as MissionAddressArguments)
            .docId;

  Stream<Mission> fetchSingleMission() => team.fetchSingleMission(docID: docId);

  displayResponseSheet() {
    final responseSheetController =
        Provider.of<ResponseSheetController>(context, listen: false);
    responseSheetController.showResponseSheet = true;
  }

  hideResponseSheet() {
    final responseSheetController =
        Provider.of<ResponseSheetController>(context, listen: false);
    responseSheetController.showResponseSheet = false;
  }

  launchChat() {
    try {
      team.launchChat();
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Error: Is Slack installed?'),
      ));
    }
  }

  launchMap(Mission mission) {
    final geoPoint = mission.location;
    final lat = geoPoint.latitude;
    final lon = geoPoint.longitude;
    // launches location in external map application.
    // currently optimized for gmaps. The location is opened
    // as a query "?q=" so the label is displayed.
    String url;
    if (Platform.isAndroid) {
      url = 'geo:0,0?q=$lat,$lon';
    } else if (Platform.isIOS || Platform.isMacOS) {
      url = 'http://maps.apple.com/?q=$lat,$lon';
    } else {
      throw Exception("Non-supported platform");
    }
    launch(url);
  }

  bool get chatURIAvailable => team.chatURI != null;

  String get email => user.email;

  String get displayName => user.displayName;

  bool get isEditor => user.isEditor;

  addResponse({@required Response response}) =>
      team.addResponse(response: response, docID: docId, uid: user.uid);

  addPage({@required missionpage.Page page}) => team.addPage(page: page);

  standDownMission({@required Mission mission}) =>
      team.standDownMission(mission: mission);
}