import 'package:flutter/cupertino.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:missionout/main.dart' as app;

void main(){
  enableFlutterDriverExtension();
  runApp(app.MissionOut());
}