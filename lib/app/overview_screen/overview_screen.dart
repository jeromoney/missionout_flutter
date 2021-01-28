import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:missionout/app/detail_screen/detail_screen.dart';
import 'package:missionout/app/my_appbar/my_appbar.dart';
import 'package:missionout/app/overview_screen/overview_screen_model.dart';
import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/mission_address_arguments.dart';
import 'package:provider/provider.dart';

class BuildMissionResults extends StatefulWidget {
  final List<Mission> missions;

  const BuildMissionResults({Key key, @required this.missions})
      : super(key: key);

  @override
  _BuildMissionResultsState createState() => _BuildMissionResultsState();
}

class BuildMissionStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = OverviewScreenModel(context);
    if (model.team == null) return const LinearProgressIndicator();

    return StreamBuilder<List<Mission>>(
        stream: model.fetchMissions(),
        builder: (context, snapshot) {
          // waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }

          // error
          if (snapshot.data == null) {
            return const Center(
              child: Text('There was an error.'),
            );
          }

          // successful query
          final missions = snapshot.data;
          // removing missions with incomplete fields. This is a little crude
          missions.removeWhere((mission) => mission == null);

          if (missions.isEmpty) {
            return const Center(
              child: Text('No recent results.'),
            );
          }

          return BuildMissionResults(
            missions: missions,
          );
        });
  }
}

class OverviewScreen extends StatelessWidget {
  static const routeName = "/overviewScreen";
  @override
  Widget build(BuildContext context) {
    // If user clicks on notification, navigate to detail screen.
    // TODO - Refactor and move firestore logic somewhere more appropriate
    // If app is running and notification is clicked, this function will run
    // If app is terminated, use getInitialMessage instead
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final documentPath = message.data["missionDocumentPath"] as String;
      final documentReference = FirebaseFirestore.instance.doc(documentPath);
      final missionAddressArguments =
          MissionAddressArguments(documentReference);
      Navigator.pushNamed(context, DetailScreen.routeName,
          arguments: missionAddressArguments);
    });

    final model = OverviewScreenModel(context);
    if (model.user == null) return const LinearProgressIndicator();
    return Scaffold(
        key: const Key("Overview Screen"),
        appBar: const MyAppBar(title: 'Overview'),
        body: BuildMissionStream(),
        floatingActionButton: model.isEditor // only show FAB to editors
            ? FloatingActionButton(
                onPressed: model.navigateToCreate,
                child: const Icon(Icons.create),
              )
            : null);
  }
}

class _BuildMissionResultsState extends State<BuildMissionResults> {
  OverviewScreenModel model;
  final _log = Logger('_BuildMissionResultsState');

  @override
  Widget build(BuildContext context) {
    model = OverviewScreenModel(context);
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          final mission = widget.missions[index];
          const strikeThroughStyle =
              TextStyle(decoration: TextDecoration.lineThrough);
          final needForActionStr = mission.needForAction ?? '';
          // Due the online/offline nature of Firestore, there is a brief moment
          // when the time can be null. So just using the current time to avoid a
          // a null issue for this brief moment. Hopefully the brief moment isn't
          // all the time.
          final DateTime dateTime = mission.time?.toDate() ?? DateTime.now();
          final String timestampStr = '${DateFormat.yMMMd().format(dateTime)} ${DateFormat.Hm().format(dateTime)}';
          return ListTile(
            title: Text(mission.description ?? '',
                style: mission.isStoodDown ?? false
                    ? Theme.of(context)
                        .textTheme
                        .bodyText2
                        .merge(strikeThroughStyle)
                    : Theme.of(context).textTheme.bodyText2),
            subtitle: Text(
                '$needForActionStr — $timestampStr'),
            onTap: () {
              model.navigateToDetail(mission: mission);
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: widget.missions.length);
  }

  @override
  void initState() {
    super.initState();
    _log.info("Checking messages");
    // Check if app was opened by mission notification
    final NotificationAppLaunchDetails notificationAppLaunchDetails =
        context.read<NotificationAppLaunchDetails>();
    // Need null check for Flutter Web
    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _log.info(
            "Received FCM payload: ${notificationAppLaunchDetails.payload}");
        // App was launched from notification so navigate directly to detail page
        directDetailScreenNavigation(
            context: context, path: notificationAppLaunchDetails.payload);
      });
    }
  }
}
