part of 'user_screen.dart';

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
    final user = Provider.of<User>(context, listen: false);
    _phoneType = Provider.of<PhoneType>(context, listen: false);
    if (_phoneType == PhoneType.mobilePhoneNumber) {
      phoneStr = user.mobilePhoneNumber;
    } else {
      phoneStr = user.voicePhoneNumber;
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
    final user = Provider.of<User>(context, listen: false);
    String phoneNumberStr;
    String labelText;
    String hintText;
    if (Provider.of<PhoneType>(context, listen: false) ==
        PhoneType.mobilePhoneNumber) {
      phoneNumberStr = user.mobilePhoneNumber;
      labelText = 'Mobile number';
      hintText = 'Number for SMS pages';
    } else {
      // phoneType is a voicePhoneNumber
      phoneNumberStr = user.voicePhoneNumber;
      labelText = 'Voice number';
      hintText = 'Number for voice pages';
    }
    controller.text = phoneNumberStr;

    return FutureBuilder(
      future: getRegion(phoneNumberStr),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return InternationalPhoneNumberInputFutureBuilder(
          snapshot: snapshot,
          labelText: labelText,
          controller: controller,
          hintText: hintText);
      },
    );
  }
}

@visibleForTesting
Future<String> getRegion(String phoneNumberStr) async {
  if (phoneNumberStr == null || phoneNumberStr.isEmpty) {
    return 'US';
  }

  PhoneNumber number =
      await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumberStr);
  return number.isoCode;
}

@visibleForTesting
class InternationalPhoneNumberInputFutureBuilder extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  int counter = 0;

  InternationalPhoneNumberInputFutureBuilder(
      {Key key,
      @required this.snapshot,
      @required this.labelText,
      @required this.hintText,
      @required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      hintText: hintText,
      textFieldController: controller,
      autoValidate: true,
      isEnabled: true,
      formatInput: true,
      onInputChanged: (PhoneNumber phoneNumber) {
        // not sure why this is required
        ;
      },
    );
  }
}
