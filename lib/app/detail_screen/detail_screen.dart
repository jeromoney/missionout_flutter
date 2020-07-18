import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:missionout/app/detail_screen/detail_screen_view_model.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:missionout/data_objects/mission_address_arguments.dart';
import 'package:missionout/services/response_sheet_controller.dart';
import 'package:provider/provider.dart';

import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/app/create_screen/create_screen.dart';
import 'package:missionout/app/my_appbar.dart';
import 'package:missionout/app/response_sheet/response_sheet.dart';
import 'package:missionout/utils.dart';
import 'package:missionout/data_objects/page.dart' as missionpage;

part 'actions_detail.w.dart';

part 'edit_detail.w.dart';

part 'info_detail.w.dart';

const BLUR = 10.0;

class DetailScreen extends StatelessWidget {
  static const String routeName = "/detailScreen";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ResponseSheetController>(
      create: (_) => null,
      child: _ControllerConsumer(),
    );
  }
}

// The onTap method needs a new context below the provider
class _ControllerConsumer extends StatefulWidget {
  final Widget _detailScreen = _DetailScreenState();
  @override
  __ControllerConsumerState createState() => __ControllerConsumerState();
}

class __ControllerConsumerState extends State<_ControllerConsumer> {
  DetailScreenViewModel _model;
  int _widgetIndex = 0;

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

  showResponseSheet(){
    setState(() {
      _widgetIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    _model = DetailScreenViewModel(context: context);
    return GestureDetector(
      onTap: () {
        setState(() {
          _widgetIndex = 0;
        });
      },
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
          )
        ],
      ),
    );

    return Consumer<ResponseSheetController>(
      builder: (_, controller, __) => GestureDetector(
          child: Builder(
            builder: (_) {
              final bool showResponseSheet = controller.showResponseSheet;
              return Stack(children: <Widget>[
                widget._detailScreen,
                showResponseSheet
                    ? ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: BLUR, sigmaX: BLUR),
                          child: Container(
                            color: Colors.black.withOpacity(0),
                          ),
                        ),
                      )
                    : Container(),
                showResponseSheet
                    ? IgnorePointer(
                        child: Center(child: ResponseSheet()),
                      )
                    : Container(),
              ]);
            },
          ),
          onTap: _model.hideResponseSheet),
    );
  }
}

class _DetailScreenState extends StatelessWidget {
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
    final model = DetailScreenViewModel(context: context);

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
