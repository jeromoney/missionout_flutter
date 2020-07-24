part of 'user_edit_screen.dart';

class PhoneEntry extends StatefulWidget {
  @override
  State createState() => _PhoneEntryState();
}

class _PhoneEntryState extends State<PhoneEntry> {
  StreamSubscription _subscription;
  bool _isShowPhoneInput = false;

  /// If user selects checkbox, phone text entry appears.
  bool _allowPhoneCalls = false;
  bool _allowTexts = false;

  @override
  void initState() {
    super.initState();
    _subscription = context
        .read<StreamController<bool>>()
        .stream
        .listen((isShowPhoneInput) =>
        setState(() {
          _isShowPhoneInput = isShowPhoneInput;
        })
    );
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isShowPhoneInput ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: IgnorePointer(
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: Column(
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
        ),
      ),
    ) : Container();
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

class _MyBlur extends StatefulWidget {
  @override
  __MyBlurState createState() => __MyBlurState();
}

class __MyBlurState extends State<_MyBlur> {
  StreamSubscription _subscription;
  bool _isShowPhoneInput = false;


  @override
  void initState() {
    super.initState();
    _subscription = context
        .read<StreamController<bool>>()
        .stream
        .listen((isShowPhoneInput) =>
        setState(() {
          _isShowPhoneInput = isShowPhoneInput;
        })
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isShowPhoneInput ? Center(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: BLUR, sigmaX: BLUR),
          child: Container(
            color: Colors.black.withOpacity(0),
          ),
        ),
      ),
    ) : Container();
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription.cancel();
    super.dispose();
  }


}
