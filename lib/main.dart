import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:missionout/core/fcm_message_handler.dart';
import 'package:missionout/core/global_navigator_key.dart';
import 'package:missionout/data_objects/is_loading_notifier.dart';
import 'package:missionout/services/firebase_link_handler.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

import 'package:missionout/services/auth_service/auth_service_adapter.dart';
import 'package:missionout/services/apple_sign_in_available.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/app/auth_widget.dart';
import 'package:missionout/app/auth_widget_builder.dart';
import 'package:missionout/services/email_secure_store.dart';

import 'app/sign_in/sign_in_manager.dart';

Future<void> main() async {
  // Fix for: Unhandled Exception: ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
  WidgetsFlutterBinding.ensureInitialized();
  // Apple sign in is only available on iOS devices, so let's check that right away.
  final appleSignInAvailable = await AppleSignInAvailable.check();

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  runApp(MyApp(appleSignInAvailable: appleSignInAvailable));
}

class MyApp extends StatelessWidget {
  const MyApp(
      {this.initialAuthServiceType = AuthServiceType.firebase,
      this.appleSignInAvailable});

  final AuthServiceType initialAuthServiceType;
  final AppleSignInAvailable appleSignInAvailable;

  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            Provider<GlobalNavigatorKey>(
              create: (_) => GlobalNavigatorKey(),
            ),
            ChangeNotifierProvider<IsLoadingNotifier>(
              create: (_) => IsLoadingNotifier(),
            ),
            Provider<AppleSignInAvailable>.value(value: appleSignInAvailable),
            Provider<FCMMessageHandler>(
              lazy: false,
              create: (context) => FCMMessageHandler(context: context),
            ),
            Provider<AuthService>(
              lazy: false,
              create: (_) => AuthServiceAdapter(
                  initialAuthServiceType: initialAuthServiceType),
              dispose: (_, AuthService authService) => authService.dispose(),
            ),
            ProxyProvider2<IsLoadingNotifier, AuthService, SignInManager>(
                create: (_) => null,
                update: (_, IsLoadingNotifier isLoadingNotifier,
                        AuthService authService, SignInManager signInManager) =>
                    SignInManager(
                      authService: authService,
                      isLoading:
                          ValueNotifier<bool>(isLoadingNotifier.isLoading),
                    )),
            Provider<EmailSecureStore>(
              lazy: false,
              create: (_) => EmailSecureStore(
                  flutterSecureStorage: FlutterSecureStorage()),
            ),
            ProxyProvider2<AuthService, EmailSecureStore, FirebaseLinkHandler>(
              lazy: false,
              update:
                  (_, AuthService authService, EmailSecureStore storage, __) =>
                      FirebaseLinkHandler(
                auth: authService,
                emailStore: storage,
              ),
            ),
          ],
          child: AuthWidgetBuilder(
            builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) =>
                AuthWidget(
              userSnapshot: userSnapshot,
            ),
          ));
}
