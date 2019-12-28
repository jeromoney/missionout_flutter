import 'package:flutter/material.dart';
import 'package:mission_out/DataLayer/mission.dart';
import 'package:mission_out/UI/detail_screen.dart';

class CreateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              if (valueAsDouble == null){
                return 'Enter a valid number';
              }
              if (-90.0 > valueAsDouble || valueAsDouble > 90.0){
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
                if (valueAsDouble == null){
                  return 'Enter a valid number';
                }
                if (-180.0 > valueAsDouble || valueAsDouble > 180.0){
                  return 'Enter a valid longitude';
                }
                return null;
              }
          ),
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
                  final lat = latitudeController.text;
                  final lon = longitudeController.text;

                  final mission = Mission(description, needForAction, locationDescription);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => DetailScreen(mission: mission)));
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
