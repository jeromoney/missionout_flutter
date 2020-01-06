import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/BLoC/bloc_provider.dart';
import 'package:missionout/BLoC/missions_bloc.dart';
import 'package:missionout/BLoC/user_bloc.dart';
import 'package:missionout/UI/overview_screen.dart';
import 'package:missionout/UI/signin_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);
    return StreamBuilder<FirebaseUser>(
      stream: userBloc.userStream,
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) {
          return SigninScreen(title: 'sometitle');
        } else {
          final missionsBloc = BlocProvider.of<MissionsBloc>(context);
          missionsBloc.domain = userBloc.domain;
          return OverviewScreen();
        }
      },
    );
  }
}
