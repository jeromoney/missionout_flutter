import 'dart:async';

import 'package:flutter/material.dart';
import 'package:missionout/app/user_screen/user_screen.dart';
import 'package:missionout/services/team/mock_team.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/mock_user.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

Widget getWidgetWithProviders(Widget widget) => MultiProvider(
      providers: [
        Provider<Team>(create: (_) => MockTeam()),
        ListenableProvider<User>(create: (_) => MockUser()),
        Provider<PhoneNumberHolder>(
          create: (_) => PhoneNumberHolder(),
        ),
        Provider<StreamController<bool>>(create: (_) => StreamController<bool>(),),
      ],
      child: MaterialApp(home: widget),
    );
