import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:missionout/app/detail_screen/detail_screen_model.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:missionout/data_objects/mission_address_arguments.dart';
import 'package:provider/provider.dart';

import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/app/my_appbar.dart';
import 'package:missionout/app/response_sheet/response_sheet.dart';
import 'package:missionout/data_objects/page.dart' as missionpage;

part 'actions_detail.w.dart';

part 'edit_detail.w.dart';

part 'info_detail.w.dart';

const BLUR = 10.0;

class DetailScreen extends StatelessWidget {
  static const String routeName = "/detailScreen";

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context).settings.arguments
    as MissionAddressArguments);
    assert(arguments?.reference != null);
    return Provider<StreamController<bool>>(
      create: (_) => StreamController<bool>(),
      child: _StreamConsumer(),
    );
  }
}

// The onTap method needs a new context below the provider
class _StreamConsumer extends StatefulWidget {
  final Widget _detailScreen = _DetailScreenBuild();

  @override
  _StreamConsumerState createState() => _StreamConsumerState();
}

class _StreamConsumerState extends State<_StreamConsumer> {
  DetailScreenModel _model;
  int _widgetIndex = 0;
  StreamSubscription _subscription;

  Widget get showResponsesWidget => Stack(children: <Widget>[
        widget._detailScreen,
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: BLUR, sigmaX: BLUR),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
        ),
        IgnorePointer(
          child: Center(child: ResponseSheet()),
        ),
      ]);

  showResponseSheet(bool isShowResponses) {
    setState(() {
      if (isShowResponses)
        _widgetIndex = 0;
      else
        _widgetIndex = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    _subscription = context
        .read<StreamController<bool>>()
        .stream
        .listen((isShowResponses) => showResponseSheet(isShowResponses));
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _model = DetailScreenModel(context);
    return GestureDetector(
      onTap: _model.hideResponseSheet,
      child: IndexedStack(
        index: _widgetIndex,
        children: <Widget>[
          widget._detailScreen,
          Stack(
            children: <Widget>[
              widget._detailScreen,
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: BLUR, sigmaX: BLUR),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),
                ),
              ),
              IgnorePointer(
                child: Center(child: ResponseSheet()),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailScreenBuild extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: MyAppBar(
        title: 'Detail',
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _DetailScreenStreamWrapper(
                  detailItem: InfoDetail,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                _DetailScreenStreamWrapper(detailItem: ActionsDetail),
                _DetailScreenStreamWrapper(detailItem: EditDetail),
              ],
            ),
          ),
        ),
      ));
}

// Stream wrapper for the individual components. Helps separate code for testing
class _DetailScreenStreamWrapper extends StatelessWidget {
  final Type detailItem;

  _DetailScreenStreamWrapper({Key key, @required this.detailItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = DetailScreenModel(context);

    return StreamBuilder<Mission>(
        stream: model.fetchSingleMission(),
        builder: (context, snapshot) {
          switch (detailItem) {
            case InfoDetail:
              {
                return InfoDetail(
                  snapshot: snapshot,
                );
              }
            case ActionsDetail:
              {
                return ActionsDetail(snapshot: snapshot);
              }
            case EditDetail:
              {
                return EditDetail(snapshot: snapshot);
              }

            default:
              {
                // Should never get here
                throw DiagnosticLevel.error;
              }
              break;
          }
        });
  }
}
