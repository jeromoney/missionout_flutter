import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/mission_address.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/Provider/team.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/response_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ActionsDetailScreen extends StatelessWidget {
  final AsyncSnapshot snapshot;

  const ActionsDetailScreen({Key key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final team = Provider.of<Team>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Baseline(
            baseline: 36,
            baselineType: TextBaseline.alphabetic,
            child: Text('Response')),
        ResponseOptions(),
        ButtonBar(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.chat),
              onPressed: team.chatURIisAvailable
                  ? () {
                      try {
                        team.launchChat();
                      } catch (e) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Error: Is Slack installed?'),
                        ));
                      }
                    }
                  : null,
            ),
            Builder(builder: (context) {
              // waiting -- just show button as disabled
              if (snapshot.connectionState == ConnectionState.waiting) {
                return IconButton(
                  onPressed: null,
                  icon: Icon(Icons.map),
                );
              }
              // error
              if (snapshot.data == null) {
                return Text("There was an error.");
              }
              // success
              final mission = snapshot.data;
              return IconButton(
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
              );
            }),
            IconButton(
              icon: Icon(Icons.people),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ResponseScreen()));
              },
            ),
          ],
        ),
      ],
    );
  }
}

class ResponseOptions extends StatefulWidget {
  ResponseOptions();

  @override
  _ResponseOptionsState createState() => _ResponseOptionsState();
}

class _ResponseOptionsState extends State<ResponseOptions> {
  int _value;
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
            final user = Provider.of<User>(context, listen: false);

            Response response;
            if (selected) {
              // If selected is equal to false, that means the user deselected the chip so we should pass a null value.
              response = Response(
                  teamMember: user.displayName, status: responseChips[index]);
            }

            setState(() {
              final user = Provider.of<User>(context, listen: false);
              final team = Provider.of<Team>(context, listen: false);
              final missionAddress =
                  Provider.of<MissionAddress>(context, listen: false);

              team.addResponse(
                response: response,
                docID: missionAddress.address,
                uid: user.uid,
              );
              _value = selected ? index : null;
            });
          },
        );
      }).toList(),
    );
  }
}
