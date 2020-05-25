import 'package:flutter/material.dart';
import 'package:missionout/data_objects/mission_address_arguments.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/page.dart' as missionpage;
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/services/Team/team.dart';
import 'package:missionout/services/User/user.dart';
import 'package:missionout/app/create_screen/create_screen.dart';
import 'package:missionout/app/my_appbar.dart';
import 'package:missionout/app/response_screen.dart';
import 'package:missionout/utils.dart';



part 'actions_detail.w.dart';
part 'edit_detail.w.dart';
part 'info_detail.w.dart';

class DetailScreen extends StatelessWidget {
  static const String routeName = "/detailScreen";

  @override
  Widget build(BuildContext context) {
    // Remove route if accessed from create screen
    return Scaffold(
        appBar: MyAppBar(title: 'Detail',),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _DetailScreenStreamWrapper(detailItem: InfoDetail,),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  _DetailScreenStreamWrapper(detailItem: ActionsDetail),
                  _DetailScreenStreamWrapper(detailItem: EditDetail),
                ],
              ),
            ),
          ),
        ));
  }
}

// Stream wrapper for the individual components. Helps separate code for testing
class _DetailScreenStreamWrapper extends StatelessWidget {
  final Type detailItem;

  _DetailScreenStreamWrapper({Key key, @required this.detailItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final team = Provider.of<Team>(context);
    final MissionAddressArguments arguments = ModalRoute.of(context).settings.arguments;


    return StreamBuilder<Mission>(
        stream: team.fetchSingleMission(
          docID: arguments.address,
        ),
        builder: (context, snapshot) {
          switch (detailItem) {
            case InfoDetail:
              {
                return InfoDetail(snapshot: snapshot,);
              }
            case ActionsDetail:
              {
                return ActionsDetail(snapshot: snapshot);
              }
            case EditDetail:
              {
                return EditDetail(snapshot: snapshot);
              }

            default:
              {
                // Should never get here
                throw DiagnosticLevel.error;
              }
              break;
          }
        });
  }
}