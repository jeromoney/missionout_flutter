import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/BLoC/bloc_provider.dart';
import 'package:missionout/BLoC/user_bloc.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/UI/detail_screen.dart';
import 'package:missionout/UI/my_appbar.dart';

class CreateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UserBloc>(context);
    return Scaffold(
      appBar: MyAppBar(
        title: Text('Create a mission'),
        context: context,
        photoURL: bloc.user.photoUrl,
      ),
      body: MissionForm(),
    );
  }
}

class MissionForm extends StatefulWidget {
  @override
  MissionFormState createState() {
    return MissionFormState();
  }
}

class MissionFormState extends State<MissionForm> {
  final _formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final actionController = TextEditingController();
  final locationController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
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
                if (valueAsDouble == null) {
                  return 'Enter a valid number';
                }
                if (-180.0 > valueAsDouble || valueAsDouble > 180.0) {
                  return 'Enter a valid longitude';
                }
                return null;
              }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              child: Text('Submit'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Processing'),
                  ));
                  final description = descriptionController.text;
                  final needForAction = actionController.text;
                  final locationDescription = locationController.text;
                  final latitude = double.parse(latitudeController.text);
                  final longitude = double.parse(longitudeController.text);
                  final geoPoint = GeoPoint(latitude, longitude);

                  final mission = Mission(description, needForAction,
                      locationDescription, geoPoint);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          DetailScreen(mission: mission)));
                }
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    actionController.dispose();
    descriptionController.dispose();
    actionController.dispose();
    locationController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }
}
