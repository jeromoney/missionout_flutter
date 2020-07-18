import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:provider/provider.dart';

import 'package:missionout/constants/strings.dart';
import 'package:missionout/data_objects/phone_number_holder.dart';
import 'package:missionout/services/user/user.dart';

import 'package:missionout/app/my_appbar.dart';

part 'phone_entry.w.dart';

class UserScreen extends StatelessWidget {
  static const routeName = "/userScreen";
  final displayNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    displayNameController.text = user.displayName;
    final phoneNumberHolder =
        PhoneNumberHolder(user.mobilePhoneNumber, user.voicePhoneNumber);
    return Provider<PhoneNumberHolder>(
      create: (_) => phoneNumberHolder,
      child: Scaffold(
          appBar: MyAppBar(title: Strings.userScreenTitle),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(user.email ?? Strings.anonymousEmail),
                  Consumer<User>(builder: (_, user, __) => Text(user.displayName ?? Strings.anonymousName),),
                  TextFormField(
                    controller: displayNameController,
                    inputFormatters: [LengthLimitingTextInputFormatter(100)],
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Provider<PhoneNumberType>(
                    create: (_) => PhoneNumberType.mobile,
                    child: PhoneEntry(),
                  ),
                  Provider<PhoneNumberType>(
                    create: (_) => PhoneNumberType.voice,
                    child: PhoneEntry(),
                  ),
                  _SubmitButton(displayNameController),
                ],
              )),
            ),
          )),
    );
  }
}

class _SubmitButton extends StatefulWidget {
  final TextEditingController displayNameController;

  _SubmitButton(this.displayNameController);

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
          onPressed: _submitUpdate,
        );
      case _ButtonState.processing:
        return RaisedButton(
          child: const SizedBox(
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
            ),
            height: 20.0,
            width: 20.0,
          ),
          onPressed: () {},
        );
      case _ButtonState.error:
        return RaisedButton(
          child: Text(Strings.submit),
          onPressed: _submitUpdate,
        );
      case _ButtonState.success:
        return Text(Strings.sucessEmoji);
    }
  }

  _submitUpdate() async {
    if (Form.of(context).validate()) {
      setState(() {
        _buttonState = _ButtonState.processing;
      });
      final user = context.read<User>();
      final phoneNumberHolder = context.read<PhoneNumberHolder>();
      final futures = <Future>[];
      try {
        // Ensure that both async functions are called before the await
        if (user.mobilePhoneNumber != phoneNumberHolder.mobilePhoneNumber) {
          futures.add(user.updatePhoneNumber(
              phoneNumber: phoneNumberHolder.mobilePhoneNumber,
              type: PhoneNumberType.mobile));
        }
        if (user.voicePhoneNumber != phoneNumberHolder.voicePhoneNumber) {
          futures.add(user.updatePhoneNumber(
              phoneNumber: phoneNumberHolder.voicePhoneNumber,
              type: PhoneNumberType.voice));
        }
        if (user.displayName != widget.displayNameController.text){
          futures.add(user.updateDisplayName(
              displayName: widget.displayNameController.text));
        }
        await Future.wait(futures);
      } on Exception catch (e) {
        PlatformAlertDialog(
          title: "Error",
          content: Strings.errorPhoneSubmission,
          defaultActionText: Strings.ok,
        ).show(context);
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
