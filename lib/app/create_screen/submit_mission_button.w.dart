part of 'create_screen.dart';

class SubmitMissionButton extends StatefulWidget {
  final Mission mission;
  final TextEditingController descriptionController;
  final TextEditingController actionController;
  final TextEditingController locationController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;

  const SubmitMissionButton(
      {Key key,
      @required this.descriptionController,
      @required this.actionController,
      @required this.locationController,
      @required this.latitudeController,
      @required this.longitudeController,
      @required this.mission})
      : super(key: key);

  @override
  _SubmitMissionButtonState createState() => _SubmitMissionButtonState();
}

class _SubmitMissionButtonState extends State<SubmitMissionButton> {
  CreateScreenModel _model;

  Mission _fetchMission() {
    // Create a mission from the form fields
    final description = widget.descriptionController.text;
    final needForAction = widget.actionController.text;
    final locationDescription = widget.locationController.text;

    GeoPoint geoPoint;
    if (widget.latitudeController.text.isEmpty) {
      // no lat/lon is given so just set to null
      geoPoint = null;
    } else {
      final latitude = double.parse(widget.latitudeController.text);
      final longitude = double.parse(widget.longitudeController.text);
      geoPoint = GeoPoint(latitude, longitude);
    }

    Mission myMission = widget.mission;
    if (myMission == null) {
      // if mission is null that means we are creating new mission
      myMission = Mission.fromApp(
        description: description,
        needForAction: needForAction,
        locationDescription: locationDescription,
        location: geoPoint,
      );
    } else {
      // update existing mission
      myMission.description = description;
      myMission.needForAction = needForAction;
      myMission.locationDescription = locationDescription;
      myMission.location = geoPoint;
    }
    return myMission;
  }

  @override
  Widget build(BuildContext context) {
    _model = CreateScreenModel(context: context);
    return RaisedButton(
      child: Text('Submit'),
      onPressed: () async {
        if (Form.of(context).validate()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Processing'),
          ));
          final myMission = _fetchMission();

          await _model.addMission(mission: myMission).then((documentReference) {
            if (documentReference == null) {
              // there was an error adding mission to database
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Error uploading mission'),
              ));
              return;
            }
            myMission.selfRef = documentReference;

            // send page to editors only
            final page = missionpage.Page.fromMission(
                creator: _model.displayName ?? "unknown user",
                mission: myMission,
                onlyEditors: true);
            _model.addPage(page: page);
            Navigator.pushReplacementNamed(context, DetailScreen.routeName,
                arguments: MissionAddressArguments(documentReference));
            ;
          });
        }
      },
    );
  }
}
