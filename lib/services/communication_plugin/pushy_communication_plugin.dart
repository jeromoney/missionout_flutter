import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';
import 'package:missionout/services/communication_plugin/communication_plugin.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

class PushyCommunicationPlugin extends CommunicationPlugin {
  final _log = Logger("PushyCommunicationPlugin");
  final _tokenList = "pushyTokens";

  @override
  String toString() => "Pushy Plugin";

  @override
  Future init() {
    Pushy.toggleFCM(true);
  }

  @override
  Future signOut() {
    // TODO: implement signOut
  }

  // Please place this code in main.dart,
  // After the import statements, and outside any Widget class (top-level)

  static void backgroundNotificationListener(Map<String, dynamic> data) {

    final _player = AudioPlayer();
    const assetPath = 'sounds/tong.m4a';
    _player.setAsset(assetPath);
    _player.play();

    Logger("PushyCommunicationPlugin").info('Received notification Pushy: $data');
  // Notification title
    final  notificationTitle = data['title'] as String ?? "Mission Alert";
    final String notificationText = data['body'] as String ?? "Received mission alert";
    Get.snackbar(notificationTitle, notificationText);
  // Clear iOS app badge number
    Pushy.clearBadge();
  }

  @override
  Future<TokenHolder> getToken() async {
    final token = await Pushy.register();
    return TokenHolder(token: token, tokenList: _tokenList);
  }

}
