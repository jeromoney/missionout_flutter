import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';
import 'package:missionout/app/user_screen/android_options_user_screen_model.dart';
import 'package:missionout/constants/sound_list.dart';

class AndroidOptionsUserScreen extends StatefulWidget {
  @override
  _AndroidOptionsUserScreenState createState() =>
      _AndroidOptionsUserScreenState();
}

class _AndroidOptionsUserScreenState extends State<AndroidOptionsUserScreen> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    final model = AndroidOptionsUserScreenModel(context);
    return ListBody(
      children: [
        ListTile(
          leading: const Icon(Icons.do_not_disturb),
          title: const Text("Override Do Not Disturb"),
          trailing: Switch(
            value: _value,
            onChanged: (bool value) {
              model.goToAndroidAppSettings();
              setState(() {
                _value = value;
              });
            },
          ),
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
  AndroidOptionsUserScreenModel _model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _alertSound = ringTones[0];

        // if (!iosSounds.contains(_model.androidSound) ||
        //     _model.androidSound == null) {
        //   _alertSound = iosSounds[0];
        // } else {
        //   //_alertSound = _model.iOSSound;
        // }
      });
    });
  }

  Future _playRingtone(soundStr) async {
    _player.stop();
    final assetPath = 'android/app/src/main/res/raw/$soundStr.mp3';
    _log.info("Playing sound at: $assetPath");
    await _player.setAsset(assetPath);
    //await _player.setVolume(_model.iOSCriticalAlertsVolume ?? 1.0);
    _player.play();
  }

  String _fileNameToDisplayName(String str) {
    String result = str.replaceAll("_", " ");
    return '${result[0].toUpperCase()}${result.substring(1)}';
  }

  @override
  Widget build(BuildContext context) {
    final model = AndroidOptionsUserScreenModel(context);
    return DropdownButton(
      value: _alertSound,
      items: ringTones
          .map((soundStr) => DropdownMenuItem<String>(
                value: soundStr,
                child: Text(_fileNameToDisplayName(soundStr)),
              ))
          .toList(),
      onChanged: (String alertSound) {
        _playRingtone(alertSound);
        model.setAlertSound(alertSound);
        setState(() {
          _alertSound = alertSound;
        });
        //_model.androidSound = _alertSound;
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
