part of 'user_edit_screen.dart';

class PhoneEntry extends StatefulWidget {
  @override
  State createState() => _PhoneEntryState();
}

class _PhoneEntryState extends State<PhoneEntry> {
  /// If user selects checkbox, phone text entry appears.
  bool _allowPhoneCalls = false;
  bool _allowTexts = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final model = UserEditScreenModel(context);
    return Align(
      alignment: Alignment.topCenter,
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Provider<PhoneNumberHolder>(
          create: (context) => PhoneNumberHolder(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: MyInternationalPhoneNumberInput(),
                ),
                CheckboxFormField(
                  title: const Text('Receive SMS text pages'),
                  subtitle: const Text('Message and data rates may apply'),
                  secondary: const Icon(
                    Icons.sms,
                    size: 24,
                  ),
                  onSaved: (value) => _allowTexts = value,
                  validator: (value) => value || _allowPhoneCalls
                      ? null
                      : "At least one option must be checked",
                ),
                CheckboxFormField(
                  title: const Text('Receive phone call pages'),
                  secondary: const Icon(
                    Icons.phone,
                    size: 24,
                  ),
                  onSaved: (value) => _allowPhoneCalls = value,
                  validator: (value) => value || _allowTexts
                      ? null
                      : "At least one option must be checked",
                ),
                Builder(
                  builder: (context) => Align(
                    alignment: const Alignment(0.66, 0),
                    child: FlatButton(
                      padding: const EdgeInsets.all(0.0),
                      textColor: Theme.of(context).primaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: () async {
                        setState(() {
                          _formKey.currentState.save();
                        });
                        if (_formKey.currentState.validate()) {
                          final uid = model.user.uid;
                          final PhoneNumber phoneNumber =
                              context.read<PhoneNumberHolder>().phoneNumber;
                          final phoneNumberRecord = PhoneNumberRecord(
                            uid: uid,
                            isoCode: phoneNumber.isoCode,
                            phoneNumber: phoneNumber.phoneNumber,
                            allowCalls: _allowPhoneCalls,
                            allowText: _allowTexts,
                          );
                          await model.addPhoneNumber(phoneNumberRecord);
                          context.read<StreamController<bool>>().add(false);
                        }
                      },
                      child: const Text("Save"),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
      countries: const ["US"],
      inputDecoration: InputDecoration(labelText: labelText),
      hintText: hintText,
      onInputChanged: (PhoneNumber phoneNumber) {
        context.read<PhoneNumberHolder>().phoneNumber = phoneNumber;
      },
    );
  }
}

class PhoneNumberHolder {
  PhoneNumber phoneNumber;
}

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {Widget title,
      Widget subtitle,
      Widget secondary,
      FormFieldSetter<bool> onSaved,
      FormFieldValidator<bool> validator,
      bool initialValue = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: AutovalidateMode.always,
            builder: (FormFieldState<bool> state) => CheckboxListTile(
                  secondary: secondary,
                  dense: state.hasError,
                  title: title,
                  value: state.value,
                  onChanged: state.didChange,
                  subtitle: state.hasError
                      ? Builder(
                          builder: (BuildContext context) => Text(
                            state.errorText,
                            style:
                                TextStyle(color: Theme.of(context).errorColor),
                          ),
                        )
                      : subtitle,
                ));
}
