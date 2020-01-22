import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/Provider/firestore_service.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:provider/provider.dart';

import 'my_international_phone_number_widget.dart';


class UserScreen extends StatelessWidget {
  final _db = FirestoreService();
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
          appBar: MyAppBar(title: 'User Options'),
          body: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  MyInternationalPhoneNumberInput(
                    controller: mobilePhoneController,
                    phoneType: PhoneType.mobilePhoneNumber,
                  ),
                  MyInternationalPhoneNumberInput(
                    controller: voicePhoneController,
                    phoneType: PhoneType.voicePhoneNumber,
                  ),
                  Text(user.displayName),
                  Text(user.email),
                  RaisedButton(
                      child: Text('Submit'),
                      onPressed: () {
                        _submitForm();
                      }),
                ],
              ))),
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      debugPrint('Form is good');
    }
  }
}
