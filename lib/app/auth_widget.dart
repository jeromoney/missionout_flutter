import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:missionout/app/mission_out_app.dart';
import 'package:missionout/data_objects/is_loading_notifier.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

/// If the app is setting up the providers, a progress indicator should be displayed.
/// If the user is null, it directs to sign in page.
/// If the user is retrieved, it sets up app.
///

class AuthWidget extends StatefulWidget {
  final AsyncSnapshot<User> userSnapshot;

  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) => Directionality(
      textDirection: TextDirection.ltr,
      child: Consumer<IsLoadingNotifier>(builder: (_, isLoadingNotifier, __) {
        AppStatus appStatus = AppStatus.waiting;
        if (isLoadingNotifier.isLoading)
          appStatus = AppStatus.waiting;
        else if (widget.userSnapshot.connectionState ==
            ConnectionState.active) {
          widget.userSnapshot.hasData
              ? appStatus = AppStatus.signedIn
              : appStatus = AppStatus.signedOut;
        }
        return MissionOutApp(
          key: UniqueKey(),
          appStatus: appStatus,
        );
      }));
}
