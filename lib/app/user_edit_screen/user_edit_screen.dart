import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:missionout/app/user_edit_screen/user_edit_screen_model.dart';
import 'package:missionout/common_widgets/my_blur.dart';
import 'package:missionout/data_objects/phone_number_record.dart';
import 'package:provider/provider.dart';

import '../my_appbar/my_appbar.dart';

part 'phone_entry.w.dart';

class UserEditScreen extends StatelessWidget {
  static const routeName = "/userEditScreen";

  @override
  Widget build(BuildContext context) {
    return Provider<StreamController<bool>>(
      create: (_) => StreamController<bool>(),
      child: Builder(
        builder: (context) => Stack(children: <Widget>[
          Scaffold(
              appBar: const MyAppBar(
                title: "Edit Profile",
              ),
              body: _UserEditScreenBody()),
          MyBlur(
            child: PhoneEntry(),
          ),
        ]),
      ),
    );
  }
}

class _UserEditScreenBody extends StatefulWidget {
  @override
  _UserEditScreenBodyState createState() => _UserEditScreenBodyState();
}

class _UserEditScreenBodyState extends State<_UserEditScreenBody> {
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final model = UserEditScreenModel(context);
    nameController.text = model.displayName;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: nameController,
                validator: (value) => model.validateName(value),
                decoration: const InputDecoration(
                  labelText: "Name",
                  filled: true,
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.66, 0),
            child: TextButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await model.updateName(nameController.text);
                  const snackbar = SnackBar(
                    content: Text("Saved name"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
              },
              child: const Text("Save"),
            ),
          ),
          const Divider(
            thickness: 2.0,
          ),
          StreamBuilder<List<PhoneNumberRecord>>(
            stream: model.phoneNumbers,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Text("Error retrieving phone numbers");
              }
              return _PhoneNumberList(snapshot.data);
            },
          ),
          ElevatedButton.icon(
            onPressed: model.showPhoneInput,
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Add Phone Number"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}

class _PhoneNumberList extends StatefulWidget {
  final List<PhoneNumberRecord> phoneNumbers;

  const _PhoneNumberList(this.phoneNumbers);

  @override
  _PhoneNumberListState createState() => _PhoneNumberListState();
}

class _PhoneNumberListState extends State<_PhoneNumberList> {
  @override
  Widget build(BuildContext context) {
    final phoneNumbers = widget.phoneNumbers;
    final model = UserEditScreenModel(context);
    if (phoneNumbers == null || phoneNumbers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("No phone numbers. Add one now."),
      );
    }
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (_, index) {
          final phoneNumberRecord = widget.phoneNumbers[index];
          final phoneNumber = phoneNumberRecord.getPhoneNumber();
          return ListTile(
              title: Text(phoneNumber.phoneNumber),
              subtitle: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.phone,
                      size: 24,
                      color: phoneNumberRecord.allowCalls ? Colors.green : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.sms,
                      size: 24,
                      color: phoneNumberRecord.allowText ? Colors.green : null,
                    ),
                  )
                ],
              ),
              trailing: IconButton(
                key: const Key("Delete Phone Number"),
                icon: const Icon(
                  Icons.remove_circle_outline,
                ),
                onPressed: () {
                  model.removePhoneNumberRecord(phoneNumberRecord);
                },
              ));
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: phoneNumbers.length);
  }
}
