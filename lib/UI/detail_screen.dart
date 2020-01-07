import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/BLoC/bloc_provider.dart';
import 'package:missionout/BLoC/missions_bloc.dart';
import 'package:missionout/BLoC/single_mission_bloc.dart';
import 'package:missionout/BLoC/user_bloc.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:missionout/UI/response_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:missionout/UI/create_screen.dart';

class DetailScreen extends StatelessWidget {
  Mission
      mission; // this is the mission passed by the overview or create screen.

  @override
  Widget build(BuildContext context) {
    // Remove route if accessed from create screen

    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final userBloc = BlocProvider.of<UserBloc>(context);
    final missionsBloc = BlocProvider.of<MissionsBloc>(context);
    mission = missionsBloc.detailMission;
    final docId = mission.reference.documentID;
    final SingleMissionBloc singleMissionBloc = SingleMissionBloc(
        teamDocID: userBloc.domain, docID: docId, uid: userBloc.user.uid);

    return Scaffold(
      appBar: MyAppBar(
        title: Text('Mission Detail'),
        photoURL: userBloc.user.photoUrl,
        context: context,
      ),
      key: _scaffoldKey,
      body: StreamBuilder<Mission>(
          stream: singleMissionBloc.mission,
          builder: (context, snapshot) {
            // waiting
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator();
            }

            // error
            if (snapshot.data == null) {
              return Text("There was an error.");
            }

            // success
            mission =
                snapshot.data; // replace the old mission with current data

            return Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Baseline(
                      baseline: 44,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        mission.description,
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ),
                    Baseline(
                      baseline: 24,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        formatTime(mission.time)+(mission.isStoodDown?' stood down':''),
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    ),
                    Baseline(
                        baseline: 32,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          mission.locationDescription,
                          style: Theme.of(context).textTheme.title,
                        )),
                    Baseline(
                      baseline: 26,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        mission.needForAction,
                        style: mission.isStoodDown ? TextStyle(decoration: TextDecoration.lineThrough): Theme.of(context).textTheme.body1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    Baseline(
                        baseline: 36,
                        baselineType: TextBaseline.alphabetic,
                        child: Text('Response')),
                    ResponseOptions(singleMissionBloc),
                    ButtonBar(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.chat),
                          onPressed: () {
                            launch('slack://channel?team=T7XTWLJAH&id=C87SW4NTA')
                                .catchError((e) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Error: Is Slack installed?'),
                              ));
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.map),
                          // If no location is provided, disable the button
                          onPressed: mission.location == null
                              ? null
                              : () {
                                  final geoPoint = mission.location;
                                  final lat = geoPoint.latitude;
                                  final lon = geoPoint.longitude;
                                  // launches location in external map application.
                                  // currently optimized for gmaps. The location is opened
                                  // as a query "?q=" so the label is displayed.
                                  launch('geo:0,0?q=$lat,$lon');
                                },
                        ),
                        IconButton(
                          icon: Icon(Icons.people),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ResponseScreen(docID: docId)));
                          },
                        ),
                      ],
                    ),
                    userBloc.isEditor ? Divider() : SizedBox.shrink(),
                    userBloc.isEditor
                        ? ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: const Text('Page Team'),
                                onPressed: () {
                                  final page = Page(action: mission.needForAction, description: mission.description);
                                  singleMissionBloc.pageTeam(page);
                                },
                              ),
                              FlatButton(
                                child: const Text('Edit'),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      CreatePopupRoute(mission));
                                },
                              ),
                              FlatButton(
                                child: Text(mission.isStoodDown? '(un)Standown' : 'Stand down'),
                                onPressed: () {
                                  singleMissionBloc.standDownMission(standDown: !mission.isStoodDown);
                                },
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

String formatTime(Timestamp time) {
  if (time == null) {
    return '';
  }
  final dateTime = time.toDate();
  return DateFormat('yyyy-MM-dd kk:mm').format(dateTime);
}

class ResponseOptions extends StatefulWidget {
  final SingleMissionBloc singleMissionBloc;

  ResponseOptions(this.singleMissionBloc);

  @override
  _ResponseOptionsState createState() =>
      _ResponseOptionsState(singleMissionBloc);
}

class _ResponseOptionsState extends State<ResponseOptions> {
  final SingleMissionBloc singleMissionBloc;
  int _value = null;
  List<String> responseChips = [
    'Responding',
    'Delayed',
    'Standby',
    'Unavailble'
  ];

  _ResponseOptionsState(this.singleMissionBloc);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: List<Widget>.generate(responseChips.length, (int index) {
        return ChoiceChip(
          label: Text(responseChips[index]),
          selected: _value == index,
          onSelected: (bool selected) {
            final userBloc = BlocProvider.of<UserBloc>(context);

            Response response;
            if (selected) {
              // If selected is equal to false, that means the user deselected the chip so we should pass a null value.
              response = Response(
                  teamMember: userBloc.user.displayName,
                  status: responseChips[index]);
            }

            setState(() {
              singleMissionBloc.addResponse(response: response);
              _value = selected ? index : null;
            });
          },
        );
      }).toList(),
    );
  }
}
