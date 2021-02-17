import 'package:flutter/material.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:missionout/app/user_screen/ios_options_user_screen_model.dart';

class IOSOptionsUserScreen extends StatefulWidget {
  @override
  _IOSOptionsUserScreenState createState() => _IOSOptionsUserScreenState();
}

class _IOSOptionsUserScreenState extends State<IOSOptionsUserScreen>
    with WidgetsBindingObserver {
  double _sliderValue = 1.0;
  bool _enableIOSCriticalAlertsToggle = false;
  bool _criticalAlertContradiction = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final staticUser = IOSOptionsUserScreenModel.getUserStatic(context);
    setState(() {
      _sliderValue = staticUser.iOSCriticalAlertsVolume;
      _enableIOSCriticalAlertsToggle = staticUser.enableIOSCriticalAlerts;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      sanityCheckCriticalAlertStatus(
          expectedStatus: _enableIOSCriticalAlertsToggle);
    });
  }

  // Critical Alert settings are held both in system settings and the database
  // so checking that both are aligned, or alerting user
  Future sanityCheckCriticalAlertStatus({@required bool expectedStatus}) async {
    final int criticalAlertStatus =
        await IOSOptionsUserScreenModel.getCriticalAlertStatus();
    // Detecting conflicting states in system settings vs database
    _criticalAlertContradiction = criticalAlertStatus == 1 && expectedStatus;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final model = IOSOptionsUserScreenModel(context);
    return ListBody(
      children: [
        ListTile(
          leading: const Icon(Icons.do_not_disturb),
          title: const Text("Allow Critical Alerts"),
          subtitle: _criticalAlertContradiction
              ? Row(
                  children: [
                    Text(
                      "Check setting",
                      style: TextStyle(color: Colors.accents[0]),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        color: Colors.accents[0],
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0),
                      onPressed: (){
                        PlatformAlertDialog(
                          title: "Enable Critical Alerts in System Settings",
                          content: "Goto Settings >> Notifications >> MissionOut >> Allow Critical Alerts.\nToggle on.",
                          defaultActionText: Strings.ok,
                        ).show(context);
                      },
                    )
                  ],
                )
              : null,
          trailing: Switch(
            onChanged: (bool isEnabled) {
              model.toggleCriticalAlerts(enable: isEnabled).then((_) =>
                  sanityCheckCriticalAlertStatus(expectedStatus: isEnabled));
              setState(() {
                _enableIOSCriticalAlertsToggle = isEnabled;
              });
            },
            value: _enableIOSCriticalAlertsToggle,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.volume_mute),
          title: Slider(
            value: _sliderValue,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
            },
            onChangeEnd: (value) {
              model.setIOSCriticalAlertsVolume(volume: value);
            },
          ),
          trailing: const Icon(Icons.volume_up),
          subtitle: const Text("Critical Alert volume"),
        ),
        ListTile(
          leading: const Icon(Icons.music_note),
          title: const Text("Alert Sound"),
          trailing: _MyDropDownMenu(),
        ),
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {}
    sanityCheckCriticalAlertStatus(
        expectedStatus: _enableIOSCriticalAlertsToggle);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class _MyDropDownMenu extends StatefulWidget {
  @override
  __MyDropDownMenuState createState() => __MyDropDownMenuState();
}

class __MyDropDownMenuState extends State<_MyDropDownMenu> {
  dynamic dropdownValue = 'Option 3';

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: dropdownValue,
      items: const <DropdownMenuItem>[
        DropdownMenuItem(
          value: 'Option 1',
          child: Text('Option 1'),
        ),
        DropdownMenuItem(
          value: 'Option 2',
          child: Text('Option 2'),
        ),
        DropdownMenuItem(
          value: 'Option 3',
          child: Text('Option 3'),
        ),
        DropdownMenuItem(
          value: 'Option 4',
          child: Text('Option 4'),
        ),
        DropdownMenuItem(
          value: 'Option 5',
          child: Text('Option 5'),
        ),
        DropdownMenuItem(
          value: 'Option 6',
          child: Text('Option 6'),
        ),
      ],
      onChanged: (value) {
        setState(() {
          dropdownValue = value;
        });
      },
    );
  }
}

