import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/Provider/firestore_service.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:provider/provider.dart';

import 'phone_entry.dart';

class UserScreen extends StatelessWidget {
  final myAppBar = MyAppBar(title: 'User Options');
  final _formKey = GlobalKey<FormState>();
  final mobilePhoneController = TextEditingController();
  final voicePhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return Scaffold(
        appBar: myAppBar,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(user.displayName),
                  Text(user.email),
                  Provider<PhoneType>.value(
                      child: PhoneEntry(
                        controller: mobilePhoneController,
                      ),
                      value: PhoneType.mobilePhoneNumber),
                  Provider<PhoneType>.value(
                      child: PhoneEntry(controller: voicePhoneController),
                      value: PhoneType.voicePhoneNumber),
                  SubmitButton(
                    formKey: _formKey,
                    voicePhoneNumberController: voicePhoneController,
                    mobilePhoneNumberController: mobilePhoneController,
                  ),
                ],
              )),
        ));
  }
}

class SubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController mobilePhoneNumberController;
  final TextEditingController voicePhoneNumberController;

  SubmitButton({Key key,
    @required this.formKey,
    @required this.mobilePhoneNumberController,
    @required this.voicePhoneNumberController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return RaisedButton(
        child: Text('Submit'),
        onPressed: () async {
          if (formKey.currentState.validate()) {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Processing'),
            ));
            final user = Provider.of<FirebaseUser>(context, listen: false);
            await FirestoreService().updatePhoneNumbers(
                uid: user.uid, mobilePhoneNumber: mobilePhoneNumberController.text, voicePhoneNumber: voicePhoneNumberController.text);
            // success
            //update ExtendedUSer
            final extendedUser = Provider.of<ExtendedUser>(context, listen: false);
            extendedUser.voicePhoneNumber = voicePhoneNumberController.text;
            extendedUser.mobilePhoneNumber = mobilePhoneNumberController.text;


          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Please correct errors in phone numbers'),
            ));
          }
        });
  }
}
