import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:missionout/app/auth_widget.dart';
import 'package:missionout/app/auth_widget_builder.dart';
import 'package:missionout/core/fcm_message_handler.dart';
import 'package:missionout/core/global_navigator_key.dart';
import 'package:missionout/core/platforms.dart';
import 'package:missionout/data_objects/is_loading_notifier.dart';
import 'package:missionout/services/apple_sign_in_available.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/auth_service/auth_service_adapter.dart';
import 'package:missionout/services/email_secure_store.dart';
import 'package:missionout/services/firebase_link_handler.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'app/sign_in/sign_in_manager.dart';

Future main() async {
  final tuple = await appSetup();
  runApp(MyApp(
    appleSignInAvailable: tuple.item1,
    notificationAppLaunchDetails: tuple.item2,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp(
      {this.initialAuthServiceType = AuthServiceType.firebase,
      this.appleSignInAvailable,
      this.notificationAppLaunchDetails,
        //TODO - I shouldn't have run in demo mode, instead demo mode should be
        // started by changing the initialAuthServiceType
      this.runInDemoMode = false});

  final AuthServiceType initialAuthServiceType;
  final AppleSignInAvailable appleSignInAvailable;
  final NotificationAppLaunchDetails notificationAppLaunchDetails;
  final bool runInDemoMode;
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
            Provider<NotificationAppLaunchDetails>.value(
                value: notificationAppLaunchDetails),
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
                      isLoadingNotifier: isLoadingNotifier,
                    )),
            Provider<EmailSecureStore>(
              lazy: false,
              create: (_) => isWeb
                  ? null
                  : EmailSecureStore(
                      flutterSecureStorage: const FlutterSecureStorage()),
            ),
            ProxyProvider2<AuthService, EmailSecureStore, FirebaseLinkHandler>(
              lazy: false,
              update: (BuildContext context,
                      AuthService authService,
                      // Firebase Dynamic Links are not supported on the web at the moment
                      EmailSecureStore storage,
                      __) =>
                  FirebaseLinkHandler(
                context: context,
                auth: authService,
                emailStore: storage,
              ),
            ),
          ],
          child: AuthWidgetBuilder(
            builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
              return AuthWidget(
                userSnapshot: userSnapshot,
                runInDemoMode: runInDemoMode,
              );
            },
          ));
}

Future<Tuple2<AppleSignInAvailable, NotificationAppLaunchDetails>>
    appSetup() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  final log = Logger("main.dart");
  log.info("Running missionout");
  // Fix for: Unhandled Exception: ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
  WidgetsFlutterBinding.ensureInitialized();
  // Apple sign in is only available on iOS devices, so let's check that right away.
  final appleSignInAvailable = AppleSignInAvailable.check();
  await Firebase.initializeApp();
  NotificationAppLaunchDetails details;
  if (!isWeb) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    log.info("Received FCM: ${details.payload}");
    log.info(
        "Was app opened by notification: ${details.didNotificationLaunchApp}");
    // Initialize receiving FCM messages
    FCMMessageHandler();
  }
  return Tuple2(appleSignInAvailable, details);
}
