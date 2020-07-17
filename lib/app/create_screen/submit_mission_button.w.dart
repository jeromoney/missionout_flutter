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

    Mission myMission;
    if (widget.mission == null) {
      // if mission is null that means we are creating new mission
      myMission = Mission.fromApp(
        description: description,
        needForAction: needForAction,
        locationDescription: locationDescription,
        location: geoPoint,
      );
    } else {
      // update existing mission
      myMission = widget.mission.clone(
        description: description,
        needForAction: needForAction,
        locationDescription: locationDescription,
        location: geoPoint,
      );
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

          try {
            await _model.addMission(mission: myMission);
          } on HttpException {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Error uploading mission'),
            ));
            return;
          }

          Navigator.pushReplacementNamed(
            context,
            DetailScreen.routeName,
          );
        }
      },
    );
  }
}
