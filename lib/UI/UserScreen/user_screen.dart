import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/Provider/firestore_service.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:provider/provider.dart';

import 'phone_entry.dart';

class UserScreen extends StatelessWidget {
  final _db = FirestoreService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final mobilePhoneController = TextEditingController();
  final voicePhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TextEditingController(),
        )
      ],
      child: Scaffold(
          key: _scaffoldKey,
          appBar: MyAppBar(title: 'User Options'),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Provider<PhoneType>.value(
                        child: PhoneEntry(controller: mobilePhoneController,),
                          value: PhoneType.mobilePhoneNumber),
                    Provider<PhoneType>.value(
                        child: PhoneEntry(controller: voicePhoneController),
                        value: PhoneType.voicePhoneNumber),
                    Text(user.displayName),
                    Text(user.email),
                    RaisedButton(
                        child: Text('Submit'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Processing'),
                            ));
                          } else {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Error'),
                            ));
                          }
                          _submitForm();
                        }),
                  ],
                )),
          )),
    );
  }

  void _submitForm() {
    /*if (_formKey.currentState.validate()) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Processing'),
      ));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Processing'),
      ));
    }*/
  }
}
