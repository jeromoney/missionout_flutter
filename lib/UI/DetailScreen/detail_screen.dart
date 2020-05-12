import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/page.dart' as missionpage;
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/Provider/Team/team.dart';
import 'package:missionout/Provider/User/user.dart';
import 'package:missionout/UI/CreateScreen/create_screen.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:missionout/UI/response_screen.dart';
import 'package:missionout/utils.dart';



part 'actions_detail.w.dart';
part 'edit_detail.w.dart';
part 'info_detail.w.dart';

class DetailScreen extends StatelessWidget {
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
                  DetailScreenStreamWrapper(detailItem: InfoDetail,),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  DetailScreenStreamWrapper(detailItem: ActionsDetail),
                  DetailScreenStreamWrapper(detailItem: EditDetail),
                ],
              ),
            ),
          ),
        ));
  }
}

// Stream wrapper for the individual components. Helps separate code for testing
class DetailScreenStreamWrapper extends StatelessWidget {
  final Type detailItem;

  DetailScreenStreamWrapper({Key key, @required this.detailItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final team = Provider.of<Team>(context);
    final user = Provider.of<User>(context);


    return StreamBuilder<Mission>(
        stream: team.fetchSingleMission(
          docID: user.currentMission,
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