import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:missionout/constants/strings.dart';
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
                  _SubmitButton(),
                ],
              )),
            ),
          )),
    );
  }
}

class _SubmitButton extends StatefulWidget {
  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

enum _ButtonState { idle, processing, error, success }

class _SubmitButtonState extends State<_SubmitButton> {
  _ButtonState _buttonState = _ButtonState.idle;

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    switch (_buttonState) {
      case _ButtonState.idle:
        return RaisedButton(
          child: Text(Strings.submit),
          onPressed: _submitPhoneNumber,
        );
      case _ButtonState.processing:
        return RaisedButton(
          child: SizedBox(child: CircularProgressIndicator(strokeWidth: 3.0,), height: 20.0,width: 20.0,),
          onPressed: () {},
        );
      case _ButtonState.error:
        return RaisedButton(
          child: Text("❌"),
          onPressed: _submitPhoneNumber,
        );
      case _ButtonState.success:
        return RaisedButton(
          child: Text(Strings.sucessEmoji),
          onPressed: _submitPhoneNumber,
        );
    }
  }

  _submitPhoneNumber() async {
    if (Form.of(context).validate()) {
      setState(() {
        _buttonState = _ButtonState.processing;
      });
      final user = Provider.of<User>(context, listen: false);
      final phoneNumberHolder =
          Provider.of<PhoneNumberHolder>(context, listen: false);
      try {
        // Ensure that both async functions are called before the await
        user.updatePhoneNumber(
            phoneNumber: phoneNumberHolder.mobilePhoneNumber,
            type: PhoneNumberType.mobile);
        await user.updatePhoneNumber(
            phoneNumber: phoneNumberHolder.voicePhoneNumber,
            type: PhoneNumberType.voice);
      } on Exception catch (e) {
        final snackbar = SnackBar(
          content: Text("Error occurred while submitting phone number."),
        );
        Scaffold.of(context).showSnackBar(snackbar);

        setState(() {
          _buttonState = _ButtonState.idle;
        });
        return;
      }
      setState(() {
        _buttonState = _ButtonState.success;
      });
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(Strings.phoneNumberError),
      ));
    }
  }
}
