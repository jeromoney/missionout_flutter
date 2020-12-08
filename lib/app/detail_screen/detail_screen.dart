import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:missionout/app/detail_screen/detail_screen_model.dart';
import 'package:missionout/app/response_sheet/response_sheet.dart';
import 'package:missionout/common_widgets/mission_map/google_mission_map.dart';
import 'package:missionout/common_widgets/my_blur.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/mission_address_arguments.dart';
import 'package:missionout/data_objects/page.dart' as missionpage;
import 'package:missionout/data_objects/response.dart';
import 'package:provider/provider.dart';

part 'actions_detail.w.dart';
part 'edit_detail.w.dart';
part 'info_detail.w.dart';

class DetailScreen extends StatelessWidget {
  static const String routeName = "/detailScreen";

  @override
  Widget build(BuildContext context) {
    final arguments =
        (ModalRoute.of(context).settings.arguments as MissionAddressArguments);
    assert(arguments?.documentReference != null);
    return Provider<StreamController<bool>>(
      create: (_) => StreamController<bool>(),
      child: Builder(
        builder: (context) => GestureDetector(
          onTap: () => context.read<StreamController<bool>>().add(false),
          child: Stack(
            children: <Widget>[
              _DetailScreenBuild(),
              MyBlur(
                child: ResponseSheet(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailScreenBuild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = DetailScreenModel(context);
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreamBuilder<LatLng>(
              stream: model.missionLocation,
              builder: (_, snapshot) {
                if (snapshot.hasError || snapshot.data == null)
                  return SafeArea(
                      child: IconButton(
                    onPressed: model.navigateToOverviewScreen,
                    color: Colors.black,
                    icon: Icon(Icons.cancel),
                    iconSize: 32,
                  ));
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();
                final location = snapshot.data;
                return Container(
                    constraints: BoxConstraints.expand(
                        height: MediaQuery.of(context).size.height / 3),
                    child: Stack(children: <Widget>[
                      StreamBuilder(builder: (_, snapshot) {
                        return GoogleMissionMap(location);
                      }),
                      SafeArea(
                          child: IconButton(
                        onPressed: model.navigateToOverviewScreen,
                        icon: Icon(
                          Icons.cancel,
                          size: 32,
                          color: Colors.white,
                        ),
                      )),
                    ]));
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 24.0),
              child: _DetailScreenStreamWrapper(
                detailItem: InfoDetail,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Divider(
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 24.0),
              child: _DetailScreenStreamWrapper(detailItem: ActionsDetail),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 24.0),
              child: _DetailScreenStreamWrapper(detailItem: EditDetail),
            ),
          ],
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
    final model = DetailScreenModel(context);

    return StreamBuilder<Mission>(
        stream: model.fetchSingleMission(),
        builder: (context, snapshot) {
          switch (detailItem) {
            case InfoDetail:
              {
                return InfoDetail(
                  snapshot: snapshot,
                );
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
