import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/Provider/firestore_service.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:provider/provider.dart';

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
    ;
  }
}

enum PhoneType { mobilePhoneNumber, voicePhoneNumber }

class MyInternationalPhoneNumberInput extends StatefulWidget {
  final TextEditingController controller;
  final PhoneType phoneType;

  const MyInternationalPhoneNumberInput(
      {Key key, @required this.controller, @required this.phoneType})
      : super(key: key);

  @override
  State createState() =>
      _MyInternationalPhoneNumberInputState(controller, phoneType);
}

class _MyInternationalPhoneNumberInputState
    extends State<MyInternationalPhoneNumberInput> {
  final TextEditingController controller;
  final PhoneType phoneType;

  _MyInternationalPhoneNumberInputState(this.controller, this.phoneType);

  @override
  Widget build(BuildContext context) {
    final extendedUser = Provider.of<ExtendedUser>(context);
    String phoneNumberStr;
    String labelText;
    String hintText;
    if (phoneType == PhoneType.mobilePhoneNumber) {
      phoneNumberStr = extendedUser.mobilePhoneNumber;
      labelText = 'Mobile number';
      hintText = 'Number for SMS pages';
    } else {
      // phoneType is a voicePhoneNumber
      phoneNumberStr = extendedUser.voicePhoneNumber;
      labelText = 'Voice number';
      hintText = 'Number for voice pages';
    }
    controller.text = phoneNumberStr;

    return FutureBuilder(
      future: getRegion(phoneNumberStr),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        String region = 'US'; // default value
        if (snapshot.hasError) {
          debugPrint('Error retrieving region info');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          // do nothing, just use default value
        } else if (snapshot.connectionState == ConnectionState.done) {
          region = snapshot.data;
        }

        return InternationalPhoneNumberInput(
          inputDecoration: InputDecoration(labelText: labelText),
          initialCountry2LetterCode: region,
          hintText: hintText,
          textFieldController: controller,
          onInputChanged: (PhoneNumber number) {
            print(number.phoneNumber);
          },
          isEnabled: true,
          formatInput: true,
        );
      },
    );
  }

  Future<String> getRegion(phoneNumberStr) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumberStr);
    return number.isoCode;
  }
}
