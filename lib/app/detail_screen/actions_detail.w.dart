part of 'detail_screen.dart';

class ActionsDetail extends StatelessWidget {
  final AsyncSnapshot snapshot;

  const ActionsDetail({Key key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = DetailScreenModel(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Baseline(
            baseline: 36,
            baselineType: TextBaseline.alphabetic,
            child: Text('Response')),
        const ResponseOptions(),
        ButtonBar(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed:
                  model.chatURIAvailable ? () => model.launchChat() : null,
            ),
            Builder(builder: (context) {
              // waiting -- just show button as disabled
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const IconButton(
                  onPressed: null,
                  icon: Icon(Icons.map),
                );
              }
              // error
              if (snapshot.data == null) {
                return const Text("There was an error.");
              }
              // success
              final mission = snapshot.data as Mission;
              return IconButton(
                icon: const Icon(Icons.map),
                // If no location is provided, disable the button
                onPressed: mission.location == null
                    ? null
                    : () => model.launchMap(mission),
              );
            }),
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: model.displayResponseSheet,
            ),
          ],
        ),
      ],
    );
  }
}

class ResponseOptions extends StatefulWidget {
  const ResponseOptions();
  @override
  _ResponseOptionsState createState() => _ResponseOptionsState();
}

class _ResponseOptionsState extends State<ResponseOptions> {
  DetailScreenModel _model;
  int _value;
  List<String> responseChips = Response.RESPONSES;

  Future getInitialResponseState() async {
    if (_value == null) {
      _value = await _model.getCurrentlySelectedResponse();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _model = DetailScreenModel(context);
    getInitialResponseState();
    return Wrap(
      spacing: 8.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: List<Widget>.generate(responseChips.length, (int index) {
        return ChoiceChip(
          label: Text(responseChips[index]),
          // TODO -- choose a suitable color
          //selectedColor: Colors.accents[1],
          selected: _value == index,
          onSelected: (bool selected) {
            Response response;
            if (selected) {
              // If selected is equal to false, that means the user deselected the chip so we should pass a null value.
              response = Response.fromApp(
                  teamMember:
                      _model.displayName == null || _model.displayName == ''
                          ? _model.email
                          : _model.displayName,
                  status: responseChips[index]);
            }
            _model.addResponse(response: response);
            setState(() {
              _value = selected ? index : null;
            });
          },
        );
      }).toList(),
    );
  }
}
