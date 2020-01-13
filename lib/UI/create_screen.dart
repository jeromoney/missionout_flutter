import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/firestore_path.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/Provider/FirestoreService.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:provider/provider.dart';

class CreateScreen extends StatelessWidget {
  final Mission mission;

  CreateScreen([Mission mission]) : this.mission = mission;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: MyAppBar(
        title: Text(mission == null ? 'Create a mission' : 'Edit mission'),
        context: context,
        photoURL: user.photoUrl,
      ),
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

  final _formKey = GlobalKey<FormState>();
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
        key: _formKey,
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
            TextFormField(
              controller: latitudeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Lat'),
              validator: (value) {
                final valueAsDouble = double.tryParse(value);
                if (longitudeController.text.isEmpty && valueAsDouble == null) {
                  // allow null values if both lat and lon are blank
                  return null;
                }

                if (valueAsDouble == null) {
                  return 'Enter a valid number';
                }
                if (-90.0 > valueAsDouble || valueAsDouble > 90.0) {
                  return 'Enter a valid latitude';
                }
                return null;
              },
            ),
            TextFormField(
                controller: longitudeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Lon'),
                validator: (value) {
                  final valueAsDouble = double.tryParse(value);
                  if (latitudeController.text.isEmpty &&
                      valueAsDouble == null) {
                    // allow null values if both lat and lon are blank
                    return null;
                  }
                  if (valueAsDouble == null) {
                    return 'Enter a valid number';
                  }
                  if (-180.0 > valueAsDouble || valueAsDouble > 180.0) {
                    return 'Enter a valid longitude';
                  }
                  return null;
                }),
            Padding(
              padding: EdgeInsets.only(
                top: 16.0,
              ),
              child: RaisedButton(
                child: Text('Submit'),
                onPressed: () {
                  _submitForm();
                },
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

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Processing'),
      ));
      final firebaseMission = fetchMission();

      final db = FirestoreService();

      db.addMission(mission: firebaseMission, teamId:'chaffeecountysarnorth.org').then((documentReference) {
        if (documentReference == null) {
          // there was an error adding mission to database
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Error uploading mission'),
          ));
          return;
        }
        firebaseMission.reference = documentReference;
        final firestorePath = Provider.of<FirestorePath>(context, listen: false);
        firestorePath.missionID = firebaseMission.reference.documentID;
        Navigator.of(context).pushReplacementNamed('/detail');
      });
    }
  }

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
