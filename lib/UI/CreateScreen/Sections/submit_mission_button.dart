import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/Provider/firestore_database.dart';
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

    Mission firebaseMission = mission;
    if (firebaseMission == null) {
      // if mission is null that means we are creating new mission
      firebaseMission =
          Mission(description, needForAction, locationDescription, geoPoint);
    } else {
      // update existing mission
      firebaseMission.description = description;
      firebaseMission.needForAction = needForAction;
      firebaseMission.locationDescription = locationDescription;
      firebaseMission.location = geoPoint;
    }
    return firebaseMission;
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
          final firebaseMission = fetchMission();

          final db = FirestoreDatabase();
          final extendedUser =
          Provider.of<ExtendedUser>(context, listen: false);

          db
              .addMission(mission: firebaseMission, teamId: extendedUser.teamID)
              .then((documentReference) {
            if (documentReference == null) {
              // there was an error adding mission to database
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Error uploading mission'),
              ));
              return;
            }
            firebaseMission.reference = documentReference;
            extendedUser.missionID = documentReference.documentID;
            Navigator.of(context).pushReplacementNamed('/detail');
          });
        }
      },
    );
  }
}