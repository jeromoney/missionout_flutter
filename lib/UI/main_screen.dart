import 'package:flutter/material.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/overview_screen.dart';
import 'package:missionout/UI/signin_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user.isLoggedIn) {
      return InitWidget();
    } else {
      return SigninScreen();
    }
  }
}

// Once the user is logged in, we still need to pull some additional information
// from firestore, so the app pauses until the operation is completed
class InitWidget extends StatefulWidget {
  @override
  State createState() => InitWidgetState();
}

class InitWidgetState extends State<InitWidget> {
  var _initialized = false;

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      return OverviewScreen();
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() => _initialized = true);
  }
}
