part of 'detail_screen.dart';

class EditDetail extends StatefulWidget {
  final AsyncSnapshot snapshot;
  const EditDetail({Key key, @required this.snapshot}) : super(key: key);
  @override
  _EditDetailState createState() => _EditDetailState();
}

class _EditDetailState extends State<EditDetail> {
  DetailScreenViewModel _model;
  @override
  Widget build(BuildContext context) {
    _model = DetailScreenViewModel(context: context);
    // waiting
    if (widget.snapshot.connectionState == ConnectionState.waiting) {
      return LinearProgressIndicator();
    }
    // error
    if (widget.snapshot.data == null) {
      return Text(Strings.errorMessage);
    }
    // success
    final Mission mission = widget.snapshot.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _model.isEditor
            ? Divider(
                thickness: 1,
              )
            : SizedBox.shrink(),
        _model.isEditor
            ? ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text(Strings.pageTeam),
                    onPressed: () async {
                      final bool requestPage = await PlatformAlertDialog(
                        title: Strings.pageTeamQuestion,
                        content: Strings.pageTeamConsequence,
                        defaultActionText: Strings.pageTeam,
                        cancelActionText: Strings.cancel,
                      ).show(context);
                      if (requestPage) {
                        final page = missionpage.Page.fromMission(
                            creator: _model.displayName ?? "unknown person",
                            mission: mission,
                            onlyEditors: false);
                        _model.addPage(page: page);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  FlatButton(
                    child: const Text('Edit'),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement(CreatePopupRoute(mission));
                    },
                  ),
                  FlatButton(
                    child: Text(
                        mission.isStoodDown ? '(un)Standown' : 'Stand down'),
                    onPressed: () {
                      mission.isStoodDown = !mission.isStoodDown;
                      _model.standDownMission(
                        mission: mission,
                      );
                    },
                  ),
                ],
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
