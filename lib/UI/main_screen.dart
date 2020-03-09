import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/overview_screen.dart';
import 'package:missionout/UI/signin_screen.dart';
import 'package:missionout/Widgets/mission_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:soundpool/soundpool.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user.isLoggedIn) {
      return OverviewScreen();
    } else {
      return SigninScreen();
    }
  }
}
