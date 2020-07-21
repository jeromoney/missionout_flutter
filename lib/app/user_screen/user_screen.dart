import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:missionout/app/user_screen/user_screen_model.dart';
import 'package:missionout/data_objects/phone_number_record.dart';
import 'package:missionout/constants/strings.dart';

import 'package:missionout/app/my_appbar.dart';

class UserScreen extends StatefulWidget {
  static const routeName = "/userScreen";

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final displayNameController = TextEditingController();

  UserScreenModel _model;

  @override
  Widget build(BuildContext context) {
    _model = UserScreenModel(context);

    displayNameController.text = _model.user.displayName;

    return Scaffold(
      appBar: MyAppBar(title: Strings.userScreenTitle),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(_model.user.email ?? Strings.anonymousEmail),
              Text(_model.user.displayName ?? Strings.anonymousName),
              TextFormField(
                controller: displayNameController,
                inputFormatters: [LengthLimitingTextInputFormatter(100)],
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              _SubmitButton(displayNameController),
              PhoneNumberList(),
            ],
          )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _model.addPhoneNumber(null);
        },
      ),
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
//    if (Form.of(context).validate()) {
//      setState(() {
//        _buttonState = _ButtonState.processing;
//      });
//      final phoneNumberHolder = context.read<PhoneNumberHolder>();
//      final futures = <Future>[];
//      try {
//        // Ensure that both async functions are called before the await
//        if (user.mobilePhoneNumber != phoneNumberHolder.mobilePhoneNumber) {
//          futures.add(user.updatePhoneNumber(
//              phoneNumber: phoneNumberHolder.mobilePhoneNumber,
//              type: PhoneNumberType.mobile));
//        }
//        if (user.voicePhoneNumber != phoneNumberHolder.voicePhoneNumber) {
//          futures.add(user.updatePhoneNumber(
//              phoneNumber: phoneNumberHolder.voicePhoneNumber,
//              type: PhoneNumberType.voice));
//        }
//        if (user.displayName != widget.displayNameController.text) {
//          futures.add(user.updateDisplayName(
//              displayName: widget.displayNameController.text));
//        }
//        await Future.wait(futures);
//      } on Exception catch (e) {
//        PlatformAlertDialog(
//          title: "Error",
//          content: Strings.errorPhoneSubmission,
//          defaultActionText: Strings.ok,
//        ).show(context);
//        setState(() {
//          _buttonState = _ButtonState.idle;
//        });
//        return;
//      }
//
//      setState(() {
//        _buttonState = _ButtonState.success;
//      });
//    } else {
//      Scaffold.of(context).showSnackBar(SnackBar(
//        content: Text(Strings.phoneNumberError),
//      ));
//    }
  }
}

class PhoneNumberList extends StatefulWidget {
  @override
  _PhoneNumberListState createState() => _PhoneNumberListState();
}

class _PhoneNumberListState extends State<PhoneNumberList> {
  UserScreenModel _model;
  List<PhoneNumberRecord> _phoneNumbers;

  @override
  Widget build(BuildContext context) {
    _model = UserScreenModel(context);

    return FutureBuilder(
        future: _model.fetchPhoneNumbers(),
        builder: (_, snapshot) {
          if (snapshot.hasError) return Text("Error");
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          _phoneNumbers = snapshot.data;
          if (_phoneNumbers == null || _phoneNumbers.length == 0)
            return Text("No phone numbers. Add one now.");

          return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final phoneNumberRecord = _phoneNumbers[index];
                final phoneNumber = phoneNumberRecord.getPhoneNumber();
                return Dismissible(
                    direction: DismissDirection.startToEnd,
                    onDismissed: (_) async {
                      await _model.removePhoneNumberRecord(phoneNumberRecord);
                      setState(() {
                        _phoneNumbers.removeAt(index);
                      });
                    },
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.red,
                      child: Icon(Icons.delete_forever),
                    ),
                    child: ListTile(
                      title: FutureBuilder(
                        future: PhoneNumber.getParsableNumber(phoneNumber),
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) return Container();
                          if (!snapshot.hasData)
                            return Text("Error with phone number");
                          return Text(snapshot.data);
                        },
                      ),
                      subtitle: Text("ooga booga"),
                    ));
              },
              separatorBuilder: (_, __) => Divider(),
              itemCount: _phoneNumbers.length);
        });
  }
}
