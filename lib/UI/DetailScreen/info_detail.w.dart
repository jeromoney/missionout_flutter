part of 'detail_screen.dart';

class InfoDetail extends StatelessWidget {
  final AsyncSnapshot snapshot;
  const InfoDetail({Key key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // waiting
    if (snapshot.connectionState == ConnectionState.waiting) {
      return LinearProgressIndicator();
    }

    // error
    if (snapshot.data == null) {
      return Text("There was an error.");
    }

    // success
    final Mission mission = snapshot.data;

    return Column(
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
              style: Theme.of(context).textTheme.headline
              ,
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
      ],
    );
  }
}

