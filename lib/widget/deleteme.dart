import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:missionout/UI/CreateScreen/Sections/submit_mission_button.dart';
import 'package:provider/provider.dart';
void main() => runApp(XXX());

class XXX extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SubmitMissionButton(
          mission: null,
          actionController: TextEditingController(),
          longitudeController: TextEditingController(),
          latitudeController: TextEditingController(),
          descriptionController: TextEditingController(),
          locationController: TextEditingController(),
        ),
      ),
    );
  }
}

