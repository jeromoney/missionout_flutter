part of 'detail_screen.dart';

class EditDetail extends StatelessWidget {
  final AsyncSnapshot snapshot;

  const EditDetail({Key key, @required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final team = Provider.of<Team>(context);
    // waiting
    if (snapshot.connectionState == ConnectionState.waiting) {
      return LinearProgressIndicator();
    }
    // error
    if (snapshot.data == null) {
      return Text(Strings.errorMessage);
    }
    // success
    final Mission mission = snapshot.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        user.isEditor
            ? Divider(
                thickness: 1,
              )
            : SizedBox.shrink(),
        user.isEditor
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
                            creator: user.displayName ?? "unknown person",
                            mission: mission,
                            onlyEditors: false);
                        team.addPage(page: page);
                        Navigator.pop(context);
                      }
                      ;
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
                      team.standDownMission(
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
