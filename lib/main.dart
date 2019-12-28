import 'package:flutter/material.dart';
import 'package:mission_out/BLoC/bloc_provider.dart';
import 'package:mission_out/BLoC/missions_bloc.dart';
import 'package:mission_out/UI/main_screen.dart';

void main() => runApp(MissionOut());

class MissionOut extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MissionsBloc>(
      bloc: MissionsBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen(),
      ),
    );
  }
}
