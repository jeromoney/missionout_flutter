part of 'editor_screen.dart';

class TeamSubmitRaisedButton extends StatefulWidget {
  final formKey;
  final chatURIController;
  final latController;
  final lonController;

  const TeamSubmitRaisedButton(
      {Key key,
      @required this.formKey,
      @required this.chatURIController,
      @required this.latController,
      @required this.lonController})
      : super(key: key);

  @override
  State createState() => TeamSubmitRaisedButtonState(
      chatURIController: chatURIController,
      latController: latController,
      lonController: lonController,
      formKey: formKey);
}

class TeamSubmitRaisedButtonState extends State<TeamSubmitRaisedButton> {
  final formKey;
  final chatURIController;
  final latController;
  final lonController;
  Icon resultIcon;

  TeamSubmitRaisedButtonState(
      {@required this.formKey,
      @required this.chatURIController,
      @required this.latController,
      @required this.lonController});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      RaisedButton(
        onPressed: () async {
          // close keyboard
          FocusScope.of(context).requestFocus(FocusNode());
          if (formKey.currentState.validate()) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
            GeoPoint geoPoint;
            if (HEADQUARTERS_FEATURE_FLAG) {
              if (latController.text == '') {
                geoPoint = null;
              } else {
                double lat = double.parse(latController.text);
                double lon = double.parse(lonController.text);
                geoPoint = GeoPoint(lat, lon);
              }
            }
            try {
              final team = Provider.of<Team>(context, listen: false);
              if (HEADQUARTERS_FEATURE_FLAG)
                await team.updateInfo(
                    geoPoint: geoPoint, chatUri: chatURIController.text);
              else await team.updateInfo(chatUri: chatURIController.text);
                Scaffold.of(context).hideCurrentSnackBar();

              team.chatURI = chatURIController.text;
              if (HEADQUARTERS_FEATURE_FLAG) team.location = geoPoint;
              setState(() {
                resultIcon = Icon(
                  Icons.check,
                  color: Colors.green,
                );
              });
            } catch (e) {
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('Error uploading information')));
              setState(() {
                resultIcon = Icon(
                  Icons.error_outline,
                  color: Colors.red,
                );
              });
            }
          }
        },
        child: Text('Submit'),
      ),
      resultIcon ?? Container()
    ]);
  }
}
