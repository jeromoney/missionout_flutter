import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:missionout/Provider/Team/team.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:missionout/core/lat_lon_input.w.dart';

part 'team_submit_raised_button.w.dart';
part 'uri_text_form_field.w.dart';

class EditorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Team Options'),
      body: SingleChildScrollView(child: EditorOptionsForm()),
    );
  }
}

class EditorOptionsForm extends StatefulWidget {
  @override
  EditorOptionsFormState createState() {
    return EditorOptionsFormState();
  }
}

class EditorOptionsFormState extends State<EditorOptionsForm> {
  @override
  Widget build(BuildContext context) {
    final team = Provider.of<Team>(context);
    final _formKey = GlobalKey<FormState>();
    final chatURIController = TextEditingController();
    chatURIController.text = team.chatURI;
    final lonController = TextEditingController();
    lonController.text = team.location?.longitude.toString();
    final latController = TextEditingController();
    latController.text = team.location?.latitude.toString();


    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(team.name ?? ''),
            ),
            URITextFormField(controller: chatURIController),
            LatLonInput(
              latController: latController,
              lonController: lonController,
              fieldDescription: 'Headquarters GPS Location in decimal degrees',
            ),
            TeamSubmitRaisedButton(
              formKey: _formKey,
              latController: latController,
              lonController: lonController,
              chatURIController: chatURIController,
            ),
          ],
        ),
      ),
    );
  }
}

