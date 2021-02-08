import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:missionout/app/my_appbar/my_appbar.dart';
import 'package:missionout/app/user_screen/user_screen_model.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/data_objects/phone_number_record.dart';

class UserScreen extends StatefulWidget {
  static const routeName = "/userScreen";

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final model = UserScreenModel(context);
    return Scaffold(
      appBar: const MyAppBar(title: Strings.userScreenTitle),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.group),
                title: Text(model.teamName),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(model.displayName),
              ),
              ListTile(
                leading: const Icon(Icons.do_not_disturb),
                title: Wrap(
                  children: [
                    const Text("Override Do Not Disturb"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                          onTap: model.displayDNDInfoText,
                          child: const Icon(Icons.info_outline)),
                    ),
                  ],
                ),
                trailing: MaterialButton(
                    onPressed: model.isDNDOverridePossible
                        ? model.DNDButtonAction
                        : null,
                    child: const Text("System Settings")),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(model.email),
              ),
              const Divider(
                thickness: 2,
              ),
              StreamBuilder(
                stream: model.phoneNumbers,
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text("Error retrieving phone numbers");
                  }
                  final phoneNumbers = snapshot.data as List<PhoneNumberRecord>;
                  if (!snapshot.hasData || phoneNumbers.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          Text("No phone numbers to receive alerts. Add one."),
                    );
                  }
                  return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        final phoneNumberRecord = phoneNumbers[index];
                        final phoneNumber = phoneNumberRecord.getPhoneNumber();
                        return FutureBuilder(
                          future: PhoneNumber.getParsableNumber(phoneNumber)
                              .catchError((e) => phoneNumber.phoneNumber),
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) return Container();
                            if (!snapshot.hasData) {
                              return const Text("Error with phone number");
                            }
                            final phoneNumberString = snapshot.data as String;
                            return ListTile(
                              title: Text(phoneNumberString),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.phone,
                                      color: phoneNumberRecord.allowCalls
                                          ? Colors.green
                                          : null,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.sms,
                                      color: phoneNumberRecord.allowText
                                          ? Colors.green
                                          : null,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: phoneNumbers.length);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: model.editUserOptions,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
