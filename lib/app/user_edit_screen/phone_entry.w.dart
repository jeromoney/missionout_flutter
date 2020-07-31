part of 'user_edit_screen.dart';

class PhoneEntry extends StatefulWidget {
  @override
  State createState() => _PhoneEntryState();
}

class _PhoneEntryState extends State<PhoneEntry> {
  /// If user selects checkbox, phone text entry appears.
  bool _allowPhoneCalls = false;
  bool _allowTexts = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0)),
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: MyInternationalPhoneNumberInput(),
            ),
            CheckboxListTile(
              secondary: Icon(
                Icons.phone,
                size: 24,
              ),
              title: Text('Receive phone call pages'),
              value: _allowPhoneCalls,
              onChanged: (value) {
                setState(() {
                  _allowPhoneCalls = !_allowPhoneCalls;
                });
              },
            ),
            CheckboxListTile(
              secondary: Icon(
                Icons.sms,
                size: 24,
              ),
              title: Text('Receive SMS text pages'),
              subtitle: Text('Message and data rates may apply'),
              value: _allowTexts,
              onChanged: (value) {
                setState(() {
                  _allowTexts = !_allowTexts;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyInternationalPhoneNumberInput extends StatefulWidget {
  @override
  State createState() => _MyInternationalPhoneNumberInputState();
}

class _MyInternationalPhoneNumberInputState
    extends State<MyInternationalPhoneNumberInput> {
  @override
  Widget build(BuildContext context) {
    String labelText;
    String hintText;

    return InternationalPhoneNumberInput(
      // This means that if the user deletes their number, they are opting to not receive pages.
      initialValue: PhoneNumber(isoCode: "US", phoneNumber: "+17199662421"),
      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      countries: ["US"],
      ignoreBlank: true,
      inputDecoration: InputDecoration(labelText: labelText),
      hintText: hintText,
      autoValidate: true,
      isEnabled: true,
      formatInput: true,
      onInputChanged: (PhoneNumber phoneNumber) {},
    );
  }
}
