import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/UI/response_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({Key key, @required this.mission}) : super(key: key);
  final Mission mission;

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      body: Center(
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
                  mission.time.toString(),
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
                  style: Theme.of(context).textTheme.body1,
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
                      launch('slack://channel?team=T7XTWLJAH&id=C87SW4NTA');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.map),
                    onPressed: () {
                      if (mission.location == null) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('No location available'),
                        ));
                        return;
                      }
                      launch('geo:0,0?q=-33.8666,151.1957(Google+Sydney)');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.people),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ResponseScreen()));
                    },
                  ),
                ],
              ),
              Divider(),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('Page Team'),
                    onPressed: () {/* ... */},
                  ),
                  FlatButton(
                    child: const Text('Edit'),
                    onPressed: () {/* ... */},
                  ),
                  FlatButton(
                    child: const Text('Stand down'),
                    onPressed: () {/* ... */},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResponseOptions extends StatefulWidget {
  @override
  _ResponseOptionsState createState() => _ResponseOptionsState();
}

class _ResponseOptionsState extends State<ResponseOptions> {
  int _value = 2;
  List<String> responseChips = [
    'Responding',
    'Delayed',
    'Standby',
    'Unavailble'
  ];
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
            _value = selected ? index : null;
          },
        );
      }).toList(),
    );
  }
}
