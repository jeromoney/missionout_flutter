part of 'detail_screen.dart';

class EditDetail extends StatefulWidget {
  final AsyncSnapshot snapshot;

  const EditDetail({Key key, @required this.snapshot}) : super(key: key);

  @override
  _EditDetailState createState() => _EditDetailState();
}

class _EditDetailState extends State<EditDetail> {
  DetailScreenModel _model;

  @override
  Widget build(BuildContext context) {
    _model = DetailScreenModel(context);
    // waiting
    if (widget.snapshot.connectionState == ConnectionState.waiting) {
      return LinearProgressIndicator();
    }
    // error
    if (widget.snapshot.data == null) {
      return Text(Strings.errorMessage);
    }
    // success
    final mission = widget.snapshot.data as Mission;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (_model.isEditor) const Divider(
                thickness: 1,
              ) else const SizedBox.shrink(),
        if (_model.isEditor) ButtonBar(
                children: <Widget>[
                  TextButton(
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
                            mission: mission);
                        _model.addPage(page: page);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(Strings.pageTeam),
                  ),
                  TextButton(
                    onPressed: () {
                      _model.navigateToCreateScreen();
                    },
                    child: const Text('Edit'),
                  ),
                  TextButton(
                    onPressed: () {
                      final newMission =
                          mission.copyWith(isStoodDown: !mission.isStoodDown);
                      _model.standDownMission(
                        mission: newMission,
                      );
                    },
                    child: Text(
                        mission.isStoodDown ? '(un)Standown' : 'Stand down'),
                  ),
                ],
              ) else const SizedBox.shrink(),
      ],
    );
  }
}
