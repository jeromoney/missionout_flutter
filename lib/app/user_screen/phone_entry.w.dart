//part of 'user_screen.dart';
//
//
//class PhoneEntry extends StatefulWidget {
//  @override
//  State createState() => _PhoneEntryState();
//}
//
//class _PhoneEntryState extends State<PhoneEntry> {
//  /// If user selects checkbox, phone text entry appears.
//  bool _phoneEntryVisible;
//
//  _PhoneEntryState();
//
//  @override
//  void initState() {
//    super.initState();
//    final user = context.read<User>();
//    final phoneType = context.read<PhoneNumberType>();
//    switch (phoneType)
//      {case PhoneNumberType.mobile:
//      _phoneEntryVisible = user.mobilePhoneNumber != null;
//        break;
//      case PhoneNumberType.voice:
//        _phoneEntryVisible = user.voicePhoneNumber != null;
//        break;}
//  }
//
//  void _phoneEntryChanged(bool checked) {
//    setState(() {
//      _phoneEntryVisible = checked;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return SizedBox(
//      width: double.infinity,
//      child: Column(
//        children: <Widget>[
//          CheckboxListTile(
//            title: Text((context.watch<PhoneNumberType>() ==
//                PhoneNumberType.mobile)
//                ? 'Receive mobile pages'
//                : 'Receive voice calls'),
//            value: _phoneEntryVisible,
//            onChanged: _phoneEntryChanged,
//          ),
//          Visibility(
//              maintainState: true,
//              visible: _phoneEntryVisible,
//              child: MyInternationalPhoneNumberInput()),
//        ],
//      ),
//    );
//  }
//}
//
//class MyInternationalPhoneNumberInput extends StatefulWidget {
//  @override
//  State createState() => _MyInternationalPhoneNumberInputState();
//}
//
//class _MyInternationalPhoneNumberInputState
//    extends State<MyInternationalPhoneNumberInput> {
//  PhoneNumberType _phoneType;
//  PhoneNumberHolder _phoneNumberHolder;
//
//  @override
//  Widget build(BuildContext context) {
//    _phoneType = context.watch<PhoneNumberType>();
//    _phoneNumberHolder = context.watch<PhoneNumberHolder>();
//
//    String labelText;
//    String hintText;
//    switch (_phoneType) {
//      case PhoneNumberType.mobile:
//        labelText = 'Mobile number';
//        hintText = 'Number for SMS pages';
//        break;
//      case PhoneNumberType.voice:
//        labelText = 'Voice number';
//        hintText = 'Number for voice pages';
//        break;
//    }
//
//    return InternationalPhoneNumberInput(
//      // This means that if the user deletes their number, they are opting to not receive pages.
//      initialValue: (_phoneType == PhoneNumberType.mobile)
//          ? _phoneNumberHolder.mobilePhoneNumber
//          : _phoneNumberHolder.voicePhoneNumber,
//      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//      countries: ["US"],
//      ignoreBlank: true,
//      inputDecoration: InputDecoration(labelText: labelText),
//      hintText: hintText,
//      autoValidate: false,
//      isEnabled: true,
//      formatInput: true,
//      onInputChanged: (PhoneNumber phoneNumber) {
//        switch (_phoneType) {
//          case PhoneNumberType.mobile:
//            _phoneNumberHolder.mobilePhoneNumber = phoneNumber;
//            break;
//          case PhoneNumberType.voice:
//            _phoneNumberHolder.voicePhoneNumber = phoneNumber;
//            break;
//        }
//      },
//    );
//  }
//}
