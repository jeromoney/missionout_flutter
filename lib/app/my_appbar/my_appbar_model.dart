import 'package:flutter/material.dart';
import 'package:missionout/app/editor_screen/editor_screen.dart';
import 'package:missionout/app/user_screen/user_screen.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

class MyAppBarModel {
  final BuildContext context;
  final User user;

  MyAppBarModel(this.context) : this.user = context.watch<User>();

  signOut() {
    final authService = context.read<AuthService>();
    authService.signOut(context: context);
  }

  navigateToUserOptions() {
    // Any screen that navigates from the app bar needs to be removed from the navigator stack
    // The code removes user and editor from the stack until the first non-options page is encountered
    Navigator.of(context).pushNamedAndRemoveUntil(
        UserScreen.routeName,
        (route) => ![UserScreen.routeName, EditorScreen.routeName]
            .contains(route.settings.name));
  }

  navigateToEditorOptions() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        EditorScreen.routeName,
        (route) => ![UserScreen.routeName, EditorScreen.routeName]
            .contains(route.settings.name));
  }
}
