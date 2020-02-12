import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/UI/CreateScreen/Sections/gps_text_form_field.dart';
import 'package:missionout/UI/CreateScreen/Sections/submit_mission_button.dart';
import 'package:missionout/UI/my_appbar.dart';

class CreateScreen extends StatelessWidget {
  final Mission mission;

  CreateScreen([Mission mission]) : this.mission = mission;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          title: mission == null ? 'Create a mission' : 'Edit mission'),
      body: MissionForm(mission),
    );
  }
}

class MissionForm extends StatefulWidget {
  final Mission mission;

  MissionForm([Mission mission]) : this.mission = mission;

  @override
  MissionFormState createState() {
    return MissionFormState(mission);
  }
}

class MissionFormState extends State<MissionForm> {
  final Mission mission;

  MissionFormState([Mission mission]) : this.mission = mission;

  final descriptionController = TextEditingController();
  final actionController = TextEditingController();
  final locationController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // set the value if editing an existing mission
    if (mission != null) {
      descriptionController.value =
          TextEditingValue(text: mission.description ?? '');
      actionController.value =
          TextEditingValue(text: mission.needForAction ?? '');
      locationController.value =
          TextEditingValue(text: mission.locationDescription ?? '');
      final latValue = mission.location?.latitude ?? '';
      final lonValue = mission.location?.latitude ?? '';
      latitudeController.value = TextEditingValue(text: latValue.toString());
      longitudeController.value = TextEditingValue(text: lonValue.toString());
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Description required';
                }
                return null;
              },
            ),
            TextFormField(
              controller: actionController,
              decoration: InputDecoration(labelText: 'Need for action'),
            ),
            TextFormField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location description'),
            ),
            GPSTextFormField(
              controller: latitudeController,
              gpsType: GPS.latitude,
              companionController: longitudeController,
            ),
            GPSTextFormField(
              controller: longitudeController,
              gpsType: GPS.longitude,
              companionController: latitudeController,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 16.0,
              ),
              child: SubmitMissionButton(
                mission: mission,
                locationController: locationController,
                latitudeController: latitudeController,
                longitudeController: longitudeController,
                actionController: actionController,
                descriptionController: descriptionController,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    actionController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }
}



class CreatePopupRoute extends PopupRoute {
  // A popup route is used so back navigation doesn't go back to this screen.
  final Mission _mission;

  CreatePopupRoute([Mission mission]) : this._mission = mission;

  @override
  Color get barrierColor => Colors.red;

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => "Close";

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return CreateScreen(_mission);
  }
}
