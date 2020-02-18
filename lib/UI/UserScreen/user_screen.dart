import 'package:flutter/material.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:provider/provider.dart';

import 'Sections/phone_entry.dart';

class UserScreen extends StatelessWidget {
  final myAppBar = MyAppBar(title: 'User Options');
  final mobilePhoneController = TextEditingController();
  final voicePhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
        appBar: myAppBar,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
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
                voicePhoneNumberController: voicePhoneController,
                mobilePhoneNumberController: mobilePhoneController,
              ),
            ],
          )),
        ));
  }
}

class SubmitButton extends StatelessWidget {
  final TextEditingController mobilePhoneNumberController;
  final TextEditingController voicePhoneNumberController;

  SubmitButton(
      {Key key,
      @required this.mobilePhoneNumberController,
      @required this.voicePhoneNumberController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text('Submit'),
        onPressed: () async {
          if (Form.of(context).validate()) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Processing'),
            ));
            final user = Provider.of<User>(context, listen: false);

            await user.updatePhoneNumbers(
                mobilePhoneNumber: mobilePhoneNumberController.text,
                voicePhoneNumber: voicePhoneNumberController.text);
            // success
            //update ExtendedUSer
            user.voicePhoneNumber = voicePhoneNumberController.text;
            user.mobilePhoneNumber = mobilePhoneNumberController.text;
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Please correct errors in phone numbers'),
            ));
          }
        });
  }
}
