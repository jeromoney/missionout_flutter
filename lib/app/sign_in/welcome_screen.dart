import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';


import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final _log = Logger('WelcomeScreen');
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _domainController = TextEditingController();
  bool _isDomainValid = true;
  bool _darkMode;

  @override
  void initState() {
    super.initState();

    // Check if AppMode has any messages to display at the sign in screen
    final message = "some welcome message";
    if (message == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackbar = SnackBar(
        content: Text(message),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    });
  }

  @override
  Widget build(BuildContext context) {
    _darkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    // allows for async validation of form
    _formKey.currentState?.validate();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: !_darkMode ? Colors.white : Colors.grey[800],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: !_darkMode
                  ? Image(
                      key: Key('Welcome Logo'),
                      image: AssetImage('graphics/missionoutlogo.png'),
                    )
                  : ColorFiltered(
                      // Inverts black logo to white
                      colorFilter: ColorFilter.matrix([
                        //R  G   B    A  Const
                        -1, 0, 0, 0, 255, //
                        0, -1, 0, 0, 255, //
                        0, 0, -1, 0, 255, //
                        0, 0, 0, 1, 0, //
                      ]),
                      child: Image(
                        image: AssetImage('graphics/missionoutlogo.png'),
                      ),
                    ),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "ooga boogs",
                        hintText: "dfdf",
                        border: UnderlineInputBorder(),
                      ),
                      controller: _domainController,
                      validator: (email) {
                        if (!_isDomainValid) return "Domain not found";
                        return null;
                      },
                    ),
                  ),
                  RaisedButton(
                    child: Text("Continue →"),
                    onPressed: () async {
                      String domain = _domainController.text;
                      await Firestore.instance
                          .document('teamDomains/domains')
                          .get()
                          .then((snapshot) {
                        final List domainList = snapshot.data["domains"];
                        setState(() {
                          _isDomainValid = domainList.contains(domain);
                        });
                        if (!_isDomainValid) return;
                        Navigator.pushNamed(context, LoginScreen.routeName,
                            arguments: domain);
                      }).catchError((error) {
                        widget._log.warning('Unable to access list of approved domains', error);
                        final snackbar = SnackBar(
                          content: Text(
                              "Error accessing database. Is the internet working?"),
                        );
                        _scaffoldKey.currentState.showSnackBar(snackbar);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
