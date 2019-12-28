import 'package:flutter/material.dart';
import 'package:mission_out/DataLayer/mission.dart';
import 'package:mission_out/UI/response_screen.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({Key key, @required this.mission}) : super(key: key);
  final Mission mission;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(mission.description),
            Text(mission.time.toString()),
            Text(mission.locationDescription),
            Text(mission.needForAction),
            Divider(),
            Text('Response'),
            ResponseOptions(),
            ButtonBar(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.chat),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.map),
                  onPressed: () {},
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
