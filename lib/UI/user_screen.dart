import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/Provider/firestore_service.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  final _db = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final extendedUser = Provider.of<ExtendedUser>(context);
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
                  Text(user.displayName),
                  Text(user.email),
                  Text(extendedUser.textPhoneNumber),
                  Text(extendedUser.voicePhoneNumber),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      print(number.phoneNumber);
                    },
                    isEnabled: true,
                    autoValidate: true,
                    formatInput: true,
                  ),
                  TextFormField(
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    onChanged: (value) async {
                      final oldSelection = mobileController.value.selection;

                    },
                    controller: mobileController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.perm_phone_msg),
                        hintText: 'Mobile phone number for SMS pages',
                        labelText: 'Mobile number'),
                    validator: (String phoneNumber) {
                      return phoneNumber.contains('A') ? 'Numbers only' : null;
                    },
                  ),
                  TextFormField(
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.phone),
                        hintText: 'Phone number for voice pages',
                        labelText: 'Phone number'),
                    validator: (String phoneNumber) {
                      return phoneNumber.contains('[A-Z]')
                          ? 'Numbers only'
                          : null;
                    },
                  ),
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
    if (_formKey.currentState.validate()){
      debugPrint('Form is good');
    };
  }

  Future<void> someMethod() async {}
}

