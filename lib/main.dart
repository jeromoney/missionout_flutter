import 'package:flutter/material.dart';
import 'package:missionout/UI/CreateScreen/create_screen.dart';
import 'package:missionout/UI/DetailScreen/detail_screen.dart';
import 'package:missionout/UI/main_screen.dart';
import 'package:missionout/my_providers.dart';
import 'package:provider/provider.dart';

void main() => runApp(MissionOut());

class MissionOut extends StatelessWidget {
  var providers;

  MissionOut({Key key, this.providers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (providers == null){
      providers = MyProviders().providers;
    }
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Mission Out',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        darkTheme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (context) => MainScreen(),
        },
      ),
    );
  }
}
