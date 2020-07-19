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
    String locationAndTime;
    if (mission.time != null && mission.locationDescription != null)
      locationAndTime =
          "${mission.locationDescription} — ${mission.timeSincePresent()}";
    final strikeThroughStyle =
        TextStyle(decoration: TextDecoration.lineThrough);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Baseline(
            baseline: 24,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              locationAndTime,
              style: mission.isStoodDown
                  ? Theme.of(context).textTheme.bodyText2.merge(strikeThroughStyle)
                  : Theme.of(context).textTheme.bodyText2,
            )),
        Baseline(
          baseline: 32,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            mission.description,
            style: mission.isStoodDown
                ? Theme.of(context)
                    .textTheme
                    .headline6
                    .merge(strikeThroughStyle)
                : Theme.of(context).textTheme.headline6,
          ),
        ),
        Baseline(
          baseline: 24,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            mission.needForAction,
            style: mission.isStoodDown
                ? Theme.of(context)
                    .textTheme
                    .bodyText1
                    .merge(strikeThroughStyle)
                : Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ],
    );
  }
}
