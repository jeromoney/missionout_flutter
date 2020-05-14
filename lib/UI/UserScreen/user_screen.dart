
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:missionout/DataLayer/phone_number_holder.dart';
import 'package:missionout/Provider/AuthService/auth_service.dart';
import 'package:provider/provider.dart';

import 'package:missionout/Provider/User/user.dart';
import 'package:missionout/UI/my_appbar.dart';

part 'phone_entry.w.dart';

class UserScreen extends StatelessWidget {
  final myAppBar = MyAppBar(title: 'User Options');

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = Provider.of<User>(context, listen: false);
    final phoneNumberHolder = PhoneNumberHolder(user.mobilePhoneNumber, user.voicePhoneNumber);
    return Provider<PhoneNumberHolder>(
      create: (_) => phoneNumberHolder,
      child: Scaffold(
          appBar: myAppBar,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(authService.displayName),
                  Text(authService.email),
                  Provider<PhoneType>.value(
                      child: PhoneEntry(),
                      value: PhoneType.mobilePhoneNumber),
                  Provider<PhoneType>.value(
                      child: PhoneEntry(),
                      value: PhoneType.voicePhoneNumber),
                  SubmitButton(),
                ],
              )),
            ),
          )),
    );
  }
}

class SubmitButton extends StatelessWidget {
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
            final phoneNumberHolder = Provider.of<PhoneNumberHolder>(context, listen: false);

            await user.updatePhoneNumbers(
                mobilePhoneNumberVal: phoneNumberHolder.mobilePhoneNumber,
                voicePhoneNumberVal: phoneNumberHolder.voicePhoneNumber);
            // success
            //update ExtendedUSer
            user.mobilePhoneNumber = phoneNumberHolder.mobilePhoneNumber;
            user.voicePhoneNumber = phoneNumberHolder.voicePhoneNumber;
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Please correct errors in phone numbers'),
            ));
          }
        });
  }
}
