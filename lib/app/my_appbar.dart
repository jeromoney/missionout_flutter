import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:missionout/app/editor_screen/editor_screen.dart';
import 'package:missionout/constants/constants.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/user/user.dart';
import 'package:missionout/app/user_screen/user_screen.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

enum Menu { signOut, userOptions, editorOptions, privacyPolicy }

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  MyAppBar({@required this.title});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final photoURLAvailable = user.photoUrl != null;
    return AppBar(title: Text(title), actions: <Widget>[
      photoURLAvailable
          ? Container(
          width: AppBar().preferredSize.height,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(user.photoUrl),
              )))
          : Icon(
        Icons.account_circle,
        size: AppBar().preferredSize.height,
      ),
      PopupMenuButton<Menu>(
        key: Key('PopupMenuButton'),
        // Used for testing, since I can't find this with find.byType
        onSelected: (Menu result) async {
          switch (result) {
            case Menu.signOut:
              {
                final bool didRequestSignOut = await PlatformAlertDialog(
                  title: 'Sign out?',
                  content: 'You will no longer receive pages.',
                  defaultActionText: 'Ok',
                  cancelActionText: 'Cancel',
                ).show(context);
                if (didRequestSignOut) {
                  // tell User to sign out
                  final authService =
                  Provider.of<AuthService>(context, listen: false);
                  authService.signOut();
                }
              }
              break;

            case Menu.userOptions:
              {
                // Any screen that navigates from the app bar needs to be removed from the navigator stack
                // The code removes user and editor from the stack until the first non-options page is encountered
                Navigator.of(context).pushNamedAndRemoveUntil(
                    UserScreen.routeName,
                        (route) =>
                    ![UserScreen.routeName, EditorScreen.routeName]
                        .contains(route.settings.name));
              }
              break;

            case Menu.editorOptions:
              {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    EditorScreen.routeName,
                        (route) =>
                    ![UserScreen.routeName, EditorScreen.routeName]
                        .contains(route.settings.name));
              }
              break;
            case Menu.privacyPolicy:
              {
                launch(Constants.privacyPolicyURL);
              }
              break;
          }
        },
        itemBuilder: (BuildContext context) =>
        <PopupMenuEntry<Menu>>[
          PopupMenuItem<Menu>(
            value: Menu.userOptions,
            child: Text('User Options'),
          ),
          if (user.isEditor)
            PopupMenuItem<Menu>(
              value: Menu.editorOptions,
              child: Text('Editor Options'),
            ),
          PopupMenuItem<Menu>(
            value: Menu.signOut,
            child: Text('Sign out'),
          ),
          PopupMenuItem<Menu>(
            value: Menu.privacyPolicy,
            child: Text('Privacy Policy'),
          ),
        ],
      )
    ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class OptionsPopupRoute extends PopupRoute {
  // A popup route is used so back navigation doesn't go back to this screen.

  // CreatePopupRoute([Mission mission]) : this._mission = mission;

  @override
  Color get barrierColor => Colors.red;

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => "Close";

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return UserScreen();
  }
}
