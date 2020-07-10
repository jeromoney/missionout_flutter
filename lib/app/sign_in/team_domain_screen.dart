import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logging/logging.dart';
import 'package:missionout/app/sign_in/sign_up_screen.dart';

const COLUMN_WIDTH = 308.0;

class TeamDomainScreen extends StatefulWidget {
  final _log = Logger('TeamDomainScreen');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _domainController = TextEditingController();
  static const routeName = '/teamDomainScreen';

  @override
  _TeamDomainScreenState createState() => _TeamDomainScreenState();
}

class _TeamDomainScreenState extends State<TeamDomainScreen> {
  bool _isDomainValid = true;
  bool _darkMode;

  @override
  Widget build(BuildContext context) {
    _darkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    // allows for async validation of form
    widget._formKey.currentState?.validate();

    return GestureDetector(
      onHorizontalDragUpdate: (details){
        if (details.delta.dx > 0) Navigator.of(context).pop();
      },
      child: Scaffold(
        body: Center(
          child: LayoutBuilder(
            builder: (context, viewportConstraints) => ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: COLUMN_WIDTH,
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                Form(
                  key: widget._formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Team Domain",
                      hintText: "your_domain.com",
                      border: UnderlineInputBorder(),
                    ),
                    controller: widget._domainController,
                    validator: (email) {
                      if (!_isDomainValid) return "Domain not found";
                      return null;
                    },
                  ),
                ),
                RaisedButton(
                  onPressed: _submitDomain,
                  child: Text('Continue →'),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  _submitDomain() async {
    String domain = widget._domainController.text;
    await Firestore.instance
        .document('teamDomains/domains')
        .get()
        .then((snapshot) {
      final List domainList = snapshot.data["domains"];
      setState(() {
        _isDomainValid = domainList.contains(domain);
      });
      if (!_isDomainValid) return;
      Navigator.pushNamed(context, SignUpScreen.routeName, arguments: domain);
    }).catchError((error) {
      widget._log.warning('Unable to access list of approved domains', error);
      final snackbar = SnackBar(
        content: Text("Error accessing database. Is the internet working?"),
      );
      widget._scaffoldKey.currentState.showSnackBar(snackbar);
    });
  }
}
