import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';
import 'package:missionout/app/user_screen/ios_options_user_screen_model.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:missionout/constants/sound_list.dart';
import 'package:missionout/constants/strings.dart';

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
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      onPressed: () {
                        PlatformAlertDialog(
                          title: "Enable Critical Alerts in System Settings",
                          content:
                              "Goto Settings >> Notifications >> MissionOut >> Allow Critical Alerts.\nToggle on.",
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
            onChanged: _enableIOSCriticalAlertsToggle
                ? (value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  }
                : null,
            onChangeEnd: (value) {
              model.setIOSCriticalAlertsVolume(volume: value);
            },
          ),
          trailing: const Icon(Icons.volume_up),
          subtitle:
              Text("Critical Alert volume: ${_sliderValue.toStringAsFixed(1)}"),
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

class __MyDropDownMenuState extends State<_MyDropDownMenu>  with RouteAware, WidgetsBindingObserver{
  final _log = Logger("MyDropDownMenu");
  dynamic _dropdownValue = iosSounds[0];
  final _player = AudioPlayer();
  String _alertSound;
  IOSOptionsUserScreenModel _model;

  Future _playRingtone(soundStr) async {
    _player.stop();
    final assetPath = 'ios/Runner/sounds/$soundStr';
    _log.info("Playing sound at: $assetPath");
    await _player.setAsset(assetPath);
    _player.play();
  }

  String _fileNameToDisplayName(String str){
    String result = str.replaceAll("_", " ");
    result = result.substring(0,result.length - 4);
    return '${result[0].toUpperCase()}${result.substring(1)}';
  }

  @override
  Widget build(BuildContext context) {
    _model = IOSOptionsUserScreenModel(context);
    return DropdownButton(
        value: _alertSound,
        items: iosSounds
            .map((soundStr) => DropdownMenuItem<String>(
                  value: soundStr,
                  child: Text(_fileNameToDisplayName(soundStr)),
                ))
            .toList(),
        onChanged: (alertSound) {
         _playRingtone(alertSound);
          setState(() {
            _alertSound = alertSound as String;
          });
          _model.setAlertSound(_alertSound);
        },
      );
  }

  @override
  void dispose() {
    _player.stop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didPush() {
    _player.stop();
    super.didPush();
  }

  @override
  void didPushNext() {
    _player.stop();
    super.didPushNext();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _player.stop();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setState(() {
      _alertSound = IOSOptionsUserScreenModel.getUserStatic(context).iOSSound;
    });
  }
}
