import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:missionout/app/user_edit_screen/user_edit_screen.dart';
import 'package:missionout/app/user_screen/user_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:missionout/constants/constants.dart';
import 'package:missionout/services/user/user.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';

import 'my_appbar_model.dart';

enum Menu { signOut, userOptions, editorOptions, privacyPolicy }

const EDITOR_OPTIONS_ENABLED = false;

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  MyAppBar({@required this.title});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    final photoURLAvailable = user.photoUrl != null;
    final model = MyAppBarModel(context);
    return AppBar(title: Text(title), actions: <Widget>[
      photoURLAvailable
          ? Container(
              width: AppBar().preferredSize.height,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(model.user.photoUrl),
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
                  model.signOut();
                }
              }
              break;

            case Menu.userOptions:
              {
                model.navigateToUserOptions();
              }
              break;

            case Menu.editorOptions:
              {
                model.navigateToEditorOptions();
              }
              break;
            case Menu.privacyPolicy:
              {
                launch(Constants.privacyPolicyURL);
              }
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          PopupMenuItem<Menu>(
            enabled: !{UserScreen.routeName, UserEditScreen.routeName}
                .contains(ModalRoute.of(context)?.settings?.name),
            value: Menu.userOptions,
            child: Text('Profile'),
          ),
          if (user.isEditor && EDITOR_OPTIONS_ENABLED)
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
