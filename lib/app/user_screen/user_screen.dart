import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:missionout/app/my_appbar/my_appbar.dart';
import 'package:missionout/app/user_screen/android_options_user_screen.dart';
import 'package:missionout/app/user_screen/ios_options_user_screen.dart';
import 'package:missionout/app/user_screen/user_screen_model.dart';
import 'package:missionout/common_widgets/my_blur.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/data_objects/phone_number_record.dart';
import 'package:provider/provider.dart';

part 'phone_entry.w.dart';
part 'phone_list.w.dart';

class UserScreen extends StatefulWidget {
  static const routeName = "/userScreen";

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Provider<StreamController<bool>>(
      create: (_) => StreamController<bool>(),
      child: Builder(
        builder: (context){return Stack(children: [
          Scaffold(
            appBar: const MyAppBar(title: Strings.userScreenTitle),
            body: _UserScreenPage(),
          ),
          MyBlur(
            child: PhoneEntry(),
          ),
        ]);},
      ),
    );
  }
}
class _UserScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = UserScreenModel(context);
    return SingleChildScrollView(
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
              leading: const Icon(Icons.email),
              title: Text(model.email),
            ),
            _AdvancedOptions(),
            const Divider(
              thickness: 2,
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
            Center(
              child: ElevatedButton.icon(
                onPressed: model.showPhoneInput,
                icon: const Icon(Icons.add, size: 18),
                label: const Text("Add Phone Number"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _AdvancedOptions extends StatefulWidget {
  @override
  __AdvancedOptionsState createState() => __AdvancedOptionsState();
}

class __AdvancedOptionsState extends State<_AdvancedOptions> {
  bool _optionsDisplayed = false;

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    if (_optionsDisplayed) {
      if (platform == TargetPlatform.iOS) {
        return IOSOptionsUserScreen();
      } else if (platform == TargetPlatform.android) {
        return AndroidOptionsUserScreen();
      } else {
        return Container();
      }
    }
    return ListTile(
      leading: const Icon(Icons.keyboard_arrow_down_sharp),
      title: const Text("Advanced"),
      subtitle: const Text("Custom Sounds, Override do not disturb"),
      onTap: () {
        setState(() {
          _optionsDisplayed = true;
        });
      },
    );
  }
}
