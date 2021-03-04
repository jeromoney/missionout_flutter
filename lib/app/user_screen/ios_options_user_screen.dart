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
  final _log = Logger("IOSOptionsUserScreen");
  double _sliderValue = 1.0;
  bool _enableIOSCriticalAlerts = false;
  bool _criticalAlertContradiction = false;
  IOSOptionsUserScreenModel _model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _model = IOSOptionsUserScreenModel(context);
      setState(() {
        _sliderValue = _model.iOSCriticalAlertsVolume ?? 1.0;
        _enableIOSCriticalAlerts = _model.enableIOSCriticalAlerts ?? false;
      });
      sanityCheckCriticalAlertStatus(expectedStatus: _enableIOSCriticalAlerts);
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
                              "Go to Settings >> Notifications >> MissionOut >> Allow Critical Alerts.\nToggle on.",
                          defaultActionText: Strings.ok,
                        ).show(context);
                      },
                    )
                  ],
                )
              : null,
          trailing: Switch(
            onChanged: (bool isEnabled) {
              _model.toggleCriticalAlerts(enable: isEnabled).then((_) =>
                  sanityCheckCriticalAlertStatus(expectedStatus: isEnabled));
              setState(() {
                _enableIOSCriticalAlerts = isEnabled;
              });
            },
            value: _enableIOSCriticalAlerts,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.volume_mute),
          title: Slider(
            value: _sliderValue,
            onChanged: _enableIOSCriticalAlerts
                ? (value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  }
                : null,
            onChangeEnd: (double volume) {
              _model.iOSCriticalAlertsVolume = volume;
            },
          ),
          trailing: const Icon(Icons.volume_up),
          subtitle:
              Text("Critical Alert volume: ${_sliderValue.toStringAsFixed(1)}"),
        ),
        ListTile(
          leading: const Icon(Icons.music_note),
          title: LayoutBuilder(builder: (_, constraints) {
            if (constraints.maxWidth < 60) {
              return Container();
            } else {
              return const Text("Alert Sound");
            }
          }),
          trailing: const _MyDropDownMenu(),
        ),
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {}
    sanityCheckCriticalAlertStatus(expectedStatus: _enableIOSCriticalAlerts);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class _MyDropDownMenu extends StatefulWidget {
  const _MyDropDownMenu() : super(key: const Key("My Dropdown Menu"));

  @override
  __MyDropDownMenuState createState() => __MyDropDownMenuState();
}

class __MyDropDownMenuState extends State<_MyDropDownMenu>
    with RouteAware, WidgetsBindingObserver {
  final _log = Logger("MyDropDownMenu");
  final _player = AudioPlayer();
  String _alertSound;
  IOSOptionsUserScreenModel _model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _model = IOSOptionsUserScreenModel(context);
      setState(() {
        if (!ringTones.contains(_model.iOSSound) || _model.iOSSound == null) {
          _alertSound = ringTones[0];
        } else {
          _alertSound = _model.iOSSound;
        }
      });
    });
  }

  Future _playRingtone(soundStr) async {
    _player.stop();
    final assetPath = 'ios/Runner/sounds/$soundStr.m4a';
    _log.info("Playing sound at: $assetPath");
    await _player.setAsset(assetPath);
    await _player.setVolume(_model.iOSCriticalAlertsVolume ?? 1.0);
    _player.play();
  }

  String _fileNameToDisplayName(String str) {
    final result = str.replaceAll("_", " ");
    return '${result[0].toUpperCase()}${result.substring(1)}';
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: _alertSound,
      items: ringTones
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
        _model.iOSSound = _alertSound;
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _player.dispose();
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
}
