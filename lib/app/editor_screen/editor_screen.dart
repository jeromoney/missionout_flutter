import 'package:flutter/material.dart';
import 'package:missionout/app/my_appbar/my_appbar.dart';
import 'package:missionout/services/team/team.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

part 'team_submit_raised_button.w.dart';
part 'uri_text_form_field.w.dart';

class EditorScreen extends StatelessWidget {
  static const routeName = "/editorScreen";

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
    final team = context.watch<Team>();
    final _formKey = GlobalKey<FormState>();
    final chatURIController = TextEditingController();
    chatURIController.text = team.chatURI;

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
            TeamSubmitRaisedButton(
              formKey: _formKey,
              chatURIController: chatURIController,
            ),
          ],
        ),
      ),
    );
  }
}
