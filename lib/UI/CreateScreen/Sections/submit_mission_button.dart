import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/mission_address.dart';
import 'package:missionout/Provider/team.dart';
import 'package:missionout/UI/DetailScreen/detail_screen.dart';
import 'package:provider/provider.dart';

class SubmitMissionButton extends StatelessWidget {
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

  @visibleForTesting
  Mission fetchMission() {
    // Create a mission from the form fields
    final description = descriptionController.text;
    final needForAction = actionController.text;
    final locationDescription = locationController.text;

    GeoPoint geoPoint;
    if (latitudeController.text.isEmpty) {
      // no lat/lon is given so just set to null
      geoPoint = null;
    } else {
      final latitude = double.parse(latitudeController.text);
      final longitude = double.parse(longitudeController.text);
      geoPoint = GeoPoint(latitude, longitude);
    }

    Mission myMission = mission;
    if (myMission == null) {
      // if mission is null that means we are creating new mission
      myMission =
          Mission(description, needForAction, locationDescription, geoPoint);
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
    return RaisedButton(
      child: Text('Submit'),
      onPressed: () {
        if (Form.of(context).validate()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Processing'),
          ));
          final myMission = fetchMission();

          final team = Provider.of<Team>(context, listen: false);

          team.addMission(mission: myMission).then((documentReference) {
            if (documentReference == null) {
              // there was an error adding mission to database
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Error uploading mission'),
              ));
              return;
            }
            myMission.reference = documentReference;
            final missionAddress =
                Provider.of<MissionAddress>(context, listen: false);
            missionAddress.address = documentReference
                .documentID; // TODO - refactor this to make it more abstract
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DetailScreen()));
          });
        }
      },
    );
  }
}
