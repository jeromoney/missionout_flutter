part of 'detail_screen.dart';

class ActionsDetail extends StatelessWidget {
  final AsyncSnapshot snapshot;

  const ActionsDetail({Key key, this.snapshot}) : super(key: key);

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
              onPressed: team.chatURI != null
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
                        String url;
                        if (Platform.isAndroid){
                          url = 'geo:0,0?q=$lat,$lon';
                        }
                        else if (Platform.isIOS || Platform.isMacOS){
                          url = 'http://maps.apple.com/?q=$lat,$lon';
                        }
                        else {
                          throw Exception("Non-supported platform");
                        }
                        launch(url);
                      },
              );
            }),
            IconButton(
              icon: Icon(Icons.people),
              onPressed: () {
                final MissionAddressArguments arguments = ModalRoute.of(context).settings.arguments;
                Navigator.of(context).pushNamed(ResponseScreen.routeName, arguments: arguments);
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
    'Unavailable'
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
                  teamMember: user.displayName == null || user.displayName == '' ? user.email : user.displayName, status: responseChips[index]);
            }

            setState(() {
              final user = Provider.of<User>(context, listen: false);
              final team = Provider.of<Team>(context, listen: false);
              final MissionAddressArguments arguments = ModalRoute.of(context).settings.arguments;

              team.addResponse(
                response: response,
                docID: arguments.docId,
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
