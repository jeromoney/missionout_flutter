part of 'user_screen.dart';

enum PhoneType { mobilePhoneNumber, voicePhoneNumber }

class PhoneEntry extends StatefulWidget {
  @override
  State createState() => _PhoneEntryState();
}

class _PhoneEntryState extends State<PhoneEntry> {
  /// If user selects checkbox, phone text entry appears.
  bool _phoneEntryVisible;

  _PhoneEntryState();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<User>(context, listen: false);
    final phoneType = Provider.of<PhoneType>(context, listen: false);
    switch (phoneType)
      {case PhoneType.mobilePhoneNumber:
      _phoneEntryVisible = user.mobilePhoneNumber != null;
        break;
      case PhoneType.voicePhoneNumber:
        _phoneEntryVisible = user.voicePhoneNumber != null;
        break;}
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
              child: MyInternationalPhoneNumberInput()),
        ],
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
  PhoneType _phoneType;
  PhoneNumberHolder _phoneNumberHolder;

  @override
  Widget build(BuildContext context) {
    _phoneType = Provider.of<PhoneType>(context, listen: false);
    _phoneNumberHolder = Provider.of<PhoneNumberHolder>(context, listen: false);

    String labelText;
    String hintText;
    switch (_phoneType) {
      case PhoneType.mobilePhoneNumber:
        labelText = 'Mobile number';
        hintText = 'Number for SMS pages';
        break;
      case PhoneType.voicePhoneNumber:
        labelText = 'Voice number';
        hintText = 'Number for voice pages';
        break;
    }

    return InternationalPhoneNumberInput(
      // This means that if the user deletes their number, they are opting to not receive pages.
      initialValue: (_phoneType == PhoneType.mobilePhoneNumber)
          ? _phoneNumberHolder.mobilePhoneNumber
          : _phoneNumberHolder.voicePhoneNumber,
      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      countries: ["US"],
      ignoreBlank: true,
      inputDecoration: InputDecoration(labelText: labelText),
      hintText: hintText,
      autoValidate: false,
      isEnabled: true,
      formatInput: true,
      onInputChanged: (PhoneNumber phoneNumber) {
        switch (_phoneType) {
          case PhoneType.mobilePhoneNumber:
            _phoneNumberHolder.mobilePhoneNumber = phoneNumber;
            break;
          case PhoneType.voicePhoneNumber:
            _phoneNumberHolder.voicePhoneNumber = phoneNumber;
            break;
        }
      },
    );
  }
}
