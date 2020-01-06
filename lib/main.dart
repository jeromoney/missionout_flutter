import 'package:flutter/material.dart';
import 'package:missionout/BLoC/bloc_provider.dart';
import 'package:missionout/BLoC/missions_bloc.dart';
import 'package:missionout/BLoC/user_bloc.dart';
import 'package:missionout/UI/create_screen.dart';
import 'package:missionout/UI/detail_screen.dart';
import 'package:missionout/UI/main_screen.dart';

void main() => runApp(MissionOut());

class MissionOut extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      bloc: UserBloc(),
      child: BlocProvider<MissionsBloc>(
        bloc: MissionsBloc(),
        child: MaterialApp(
          title: 'Mission Out',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          darkTheme: ThemeData.dark(),
          initialRoute: '/',
          routes: {
            '/': (context) => MainScreen(),
            '/detail': (context) => DetailScreen(),
            '/create': (context) => CreateScreen(),
          },
        ),
      ),
    );
  }
}
