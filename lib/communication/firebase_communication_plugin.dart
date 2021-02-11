import 'package:firebase_core/firebase_core.dart';
import 'package:missionout/communication/communication_plugin.dart';

class FirebaseCommunicationPlugin extends CommunicationPlugin{
  @override
  Future init() async {
    await Firebase.initializeApp();
  }
}