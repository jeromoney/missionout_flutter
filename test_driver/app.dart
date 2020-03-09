import 'package:flutter/cupertino.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:missionout/main.dart' as app;
import 'package:missionout/my_providers.dart';

void main(){
  enableFlutterDriverExtension();
  runApp(app.MissionOut());
}