import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/app/create_screen/create_screen_model.dart';

import 'package:missionout/data_objects/mission.dart';
import 'package:missionout/app/my_appbar/my_appbar.dart';
import 'package:missionout/core/lat_lon_input.w.dart';
import 'package:provider/provider.dart';

part 'submit_mission_button.w.dart';

class CreateScreen extends StatelessWidget {
  final DocumentReference documentReference;
  CreateScreen({this.documentReference});

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: documentReference,
      child: Builder(
        builder: (context) {
          final model = CreateScreenModel(context);
          return Scaffold(
            appBar: MyAppBar(
                title: model.isEditExistingMission
                    ? 'Edit mission'
                    : 'Create a mission'),
            body: _MissionForm(),
          );
        },
      ),
    );
  }
}

class _MissionForm extends StatefulWidget {
  @override
  __MissionFormState createState() => __MissionFormState();
}

class __MissionFormState extends State<_MissionForm> {
  final descriptionController = TextEditingController();
  final actionController = TextEditingController();
  final locationController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final model = CreateScreenModel(context);
    // set the value if editing an existing mission

    return FutureBuilder(
      future: model.getCurrentMission(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
        final mission = snapshot.data;
        if (mission != null) {
          descriptionController.text = mission.description ?? '';
          actionController.text = mission.needForAction ?? '';
          locationController.text = mission.locationDescription ?? '';
          final latValue = mission.location?.latitude ?? '';
          final lonValue = mission.location?.longitude ?? '';
          latitudeController.text = latValue.toString();
          longitudeController.text = lonValue.toString();
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Description required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: actionController,
                      decoration: InputDecoration(
                          labelText: 'Need for action',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: locationController,
                      decoration: InputDecoration(
                          labelText: 'Location description',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  LatLonInput(
                    fieldDescription: 'GPS coordinates in Decimal Degrees',
                    lonController: longitudeController,
                    latController: latitudeController,
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
          ),
        );
      },
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
  final DocumentReference documentReference;

  CreatePopupRoute({this.documentReference});

  // A popup route is used so back navigation doesn't go back to this screen.

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
    return CreateScreen(
      documentReference: documentReference,
    );
  }
}
