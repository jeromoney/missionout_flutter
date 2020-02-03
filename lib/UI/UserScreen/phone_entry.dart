import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:provider/provider.dart';

enum PhoneType { mobilePhoneNumber, voicePhoneNumber }

class PhoneEntry extends StatefulWidget {
  final TextEditingController controller;

  const PhoneEntry({Key key, @required this.controller}) : super(key: key);

  @override
  State createState() => _PhoneEntryState(controller);
}

class _PhoneEntryState extends State<PhoneEntry> {
  /// If user selects checkbox, phone text entry appears.
  final TextEditingController controller;
  PhoneType _phoneType;
  bool _phoneEntryVisible;

  _PhoneEntryState(this.controller);

  @override
  void initState() {
    super.initState();
    String phoneStr;
    final extendedUser = Provider.of<ExtendedUser>(context, listen: false);
    _phoneType = Provider.of<PhoneType>(context, listen: false);
    if (_phoneType == PhoneType.mobilePhoneNumber) {
      phoneStr = extendedUser.mobilePhoneNumber;
    } else {
      phoneStr = extendedUser.voicePhoneNumber;
    }
    _phoneEntryVisible = phoneStr.isNotEmpty;
  }

  void _phoneEntryChanged(bool checked) {
    setState(() {
      _phoneEntryVisible = checked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          CheckboxListTile(
            title: Text((Provider.of<PhoneType>(context, listen: false) ==
                    PhoneType.mobilePhoneNumber)
                ? 'Receive mobile pages'
                : 'Receive voice calls'),
            value: _phoneEntryVisible,
            onChanged: _phoneEntryChanged,
          ),
          Visibility(
              maintainState: true,
              visible: _phoneEntryVisible,
              child: MyInternationalPhoneNumberInput(
                controller: controller,
              )),
        ],
      ),
    );
  }
}

class MyInternationalPhoneNumberInput extends StatefulWidget {
  final TextEditingController controller;

  const MyInternationalPhoneNumberInput({Key key, @required this.controller})
      : super(key: key);

  @override
  State createState() => _MyInternationalPhoneNumberInputState(controller);
}

class _MyInternationalPhoneNumberInputState
    extends State<MyInternationalPhoneNumberInput> {
  final TextEditingController controller;

  _MyInternationalPhoneNumberInputState(this.controller);

  @override
  Widget build(BuildContext context) {
    final extendedUser = Provider.of<ExtendedUser>(context, listen: false);
    String phoneNumberStr;
    String labelText;
    String hintText;
    if (Provider.of<PhoneType>(context, listen: false) ==
        PhoneType.mobilePhoneNumber) {
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
          // This means that if the user deletes their number, they are opting to not receive pages.
          ignoreBlank: true,
          inputDecoration: InputDecoration(labelText: labelText),
          initialCountry2LetterCode: region,
          hintText: hintText,
          textFieldController: controller,
          autoValidate: true,
          isEnabled: true,
          formatInput: true,
          onInputChanged: (PhoneNumber phoneNumber) {},
        );
      },
    );
  }

  Future<String> getRegion(String phoneNumberStr) async {
    if (phoneNumberStr.isEmpty) {
      return 'US';
    }

    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumberStr);
    return number.isoCode;
  }
}
