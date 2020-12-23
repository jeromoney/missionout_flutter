import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:missionout/app/my_appbar/my_appbar.dart';
import 'package:missionout/app/overview_screen/overview_screen_model.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:provider/provider.dart';

class OverviewScreen extends StatefulWidget {
  final _log = Logger('OverviewScreen');
  static const routeName = "/overviewScreen";

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  void initState() {
    super.initState();
    // Check if app was opened by mission notification
    final NotificationAppLaunchDetails notificationAppLaunchDetails =
        context.read<NotificationAppLaunchDetails>();
    // Need null check for Flutter Web
    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp) {

      SchedulerBinding.instance.addPostFrameCallback((_) {
        widget._log.info("Received FCM payload: ${notificationAppLaunchDetails.payload}");
        // App was launched from notification so navigate directly to detail page
        directDetailScreenNavigation(context: context, path: notificationAppLaunchDetails.payload);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = OverviewScreenModel(context);
    if (model.user == null) return LinearProgressIndicator();
    return Scaffold(
        key: Key("Overview Screen"),
        appBar: MyAppBar(title: 'Overview'),
        body: BuildMissionStream(),
        floatingActionButton: model.isEditor // only show FAB to editors
            ? FloatingActionButton(
                child: Icon(Icons.create),
                onPressed: model.navigateToCreate,
              )
            : null);
  }
}

class BuildMissionStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = OverviewScreenModel(context);
    if (model.team == null) return LinearProgressIndicator();

    return StreamBuilder<List<Mission>>(
        stream: model.fetchMissions(),
        builder: (context, snapshot) {
          // waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator();
          }

          // error
          if (snapshot.data == null) {
            return Center(
              child: Text('There was an error.'),
            );
          }

          // successful query
          final missions = snapshot.data;
          // removing missions with incomplete fields. This is a little crude
          missions.removeWhere((mission) => mission == null);

          if (missions.length == 0) {
            return Center(
              child: Text('No recent results.'),
            );
          }

          return BuildMissionResults(
            missions: missions,
          );
        });
  }
}

class BuildMissionResults extends StatefulWidget {
  final List<Mission> missions;

  const BuildMissionResults({Key key, @required this.missions})
      : super(key: key);

  @override
  _BuildMissionResultsState createState() => _BuildMissionResultsState();
}

class _BuildMissionResultsState extends State<BuildMissionResults> {
  OverviewScreenModel model;

  @override
  Widget build(BuildContext context) {
    model = OverviewScreenModel(context);
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          final mission = widget.missions[index];
          final strikeThroughStyle =
              TextStyle(decoration: TextDecoration.lineThrough);
          return ListTile(
            title: Text(mission.description ?? '',
                style: mission.isStoodDown ?? false
                    ? Theme.of(context)
                        .textTheme
                        .bodyText2
                        .merge(strikeThroughStyle)
                    : Theme.of(context).textTheme.bodyText2),
            subtitle: Text((mission.needForAction ?? '') +
                ' — ' +
                (DateFormat.yMMMd().format(mission.time.toDate()) ?? '')),
            onTap: () {
              model.navigateToDetail(mission: mission);
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: widget.missions.length);
  }
}
