import 'package:flutter/material.dart';
import 'package:mission_out/DataLayer/mission.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({Key key, @required this.mission}) : super(key: key);
  final Mission mission;
  int _value = 2;
  List<String> responseChips = [
    'Responding',
    'Delayed',
    'Standby',
    'Unavailble'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(mission.description),
            Text(mission.time.toString()),
            Text(mission.locationDescription),
            Text(mission.needForAction),
            Divider(),
            Text('Response'),
            Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children:
                  List<Widget>.generate(responseChips.length, (int index) {
                return ChoiceChip(
                  label: Text(responseChips[index]),
                  selected: _value == index,
                  onSelected: (bool selected) {
                    _value = selected ? index : null;
                  },
                );
              }).toList(),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {/* ... */},
                ),
                FlatButton(
                  child: const Text('LISTEN'),
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
