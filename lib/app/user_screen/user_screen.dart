import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:missionout/data_objects/phone_number_holder.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

import 'package:missionout/app/my_appbar.dart';

part 'phone_entry.w.dart';

class UserScreen extends StatelessWidget {
  final myAppBar = MyAppBar(title: 'User Options');
  static const routeName = "/userScreen";

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = Provider.of<User>(context, listen: false);
    final phoneNumberHolder =
        PhoneNumberHolder(user.mobilePhoneNumber, user.voicePhoneNumber);
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
                  Text(user.displayName ?? "anonymous"),
                  Text(user.email ?? "unknown email"),
                  Provider<PhoneNumberType>(
                    create: (_) => PhoneNumberType.mobile,
                    child: PhoneEntry(),
                  ),
                  Provider<PhoneNumberType>(
                    create: (_) => PhoneNumberType.voice,
                    child: PhoneEntry(),
                  ),
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
            final phoneNumberHolder =
                Provider.of<PhoneNumberHolder>(context, listen: false);
            await user.updatePhoneNumber(
                phoneNumber: phoneNumberHolder.mobilePhoneNumber,
                type: PhoneNumberType.mobile);
            await user.updatePhoneNumber(
                phoneNumber: phoneNumberHolder.voicePhoneNumber,
                type: PhoneNumberType.voice);

            //update User
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
