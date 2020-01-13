import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/firestore_path.dart';
import 'package:missionout/Provider/FirestoreService.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:missionout/UI/response_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:missionout/UI/create_screen.dart';

class DetailScreen extends StatelessWidget {
  final db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    // Remove route if accessed from create screen

    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      appBar: MyAppBar(
        title: Text('Mission Detail'),
        photoURL: user.photoUrl,
        context: context,
      ),
      key: _scaffoldKey,
      body: StreamBuilder<Mission>(
          stream: db.fetchSingleMission(
              teamID: Provider.of<FirestorePath>(context).teamID,
              docID: Provider.of<FirestorePath>(context).missionID),
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
            final mission =
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
                        formatTime(mission.time) +
                            (mission.isStoodDown ? ' stood down' : ''),
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
                        style: mission.isStoodDown
                            ? TextStyle(decoration: TextDecoration.lineThrough)
                            : Theme.of(context).textTheme.body1,
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
                    ResponseOptions(),
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
                                    ResponseScreen()));
                          },
                        ),
                      ],
                    ),
                    true ? Divider() : SizedBox.shrink(),
                    true
                        ? ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: const Text('Page Team'),
                                onPressed: () {
                                  final page = Page(
                                      action: mission.needForAction,
                                      description: mission.description);
                                  db.addPage(teamID: 'chaffeecountysarnorth.org', missionDocID: mission.reference.documentID, page: page);
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
                                child: Text(mission.isStoodDown
                                    ? '(un)Standown'
                                    : 'Stand down'),
                                onPressed: () {
                                  db.standDownMission(standDown: !mission.isStoodDown, docID: mission.reference.documentID, teamID: 'chaffeecountysarnorth.org');
                                  //singleMissionBloc.standDownMission(standDown: !mission.isStoodDown);
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
  ResponseOptions();

  @override
  _ResponseOptionsState createState() => _ResponseOptionsState();
}

class _ResponseOptionsState extends State<ResponseOptions> {
  int _value = null;
  List<String> responseChips = [
    'Responding',
    'Delayed',
    'Standby',
    'Unavailble'
  ];

  _ResponseOptionsState();

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
            final user = Provider.of<FirebaseUser>(context, listen: false);

            Response response;
            if (selected) {
              // If selected is equal to false, that means the user deselected the chip so we should pass a null value.
              response = Response(
                  teamMember: user.displayName, status: responseChips[index]);
            }

            setState(() {
              final user = Provider.of<FirebaseUser>(context, listen: false);
              final firestorePath = Provider.of<FirestorePath>(context, listen: false);

              FirestoreService().addResponse(
                  response: response,
                  uid: user.uid,
                  teamID: firestorePath.teamID,
                  docID: firestorePath.missionID);
              _value = selected ? index : null;
            });
          },
        );
      }).toList(),
    );
  }
}
