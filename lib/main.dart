import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

import 'app/sign_in/sign_in_manager.dart';

Future main() async {
  // Fix for: Unhandled Exception: ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
  WidgetsFlutterBinding.ensureInitialized();
  // Apple sign in is only available on iOS devices, so let's check that right away.
  final appleSignInAvailable = AppleSignInAvailable.check();
  await Firebase.initializeApp();
  if (!Platforms.isWeb) {
    FCMMessageHandler.initializeAndroidChannel();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
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
              // Notifications aren't supported on web at the moment
              create: (context) => Platforms.isWeb ? null : FCMMessageHandler(context: context),
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
                      isLoadingNotifier: isLoadingNotifier,
                    )),
            Provider<EmailSecureStore>(
              lazy: false,
              create: (_) => Platforms.isWeb ? null : EmailSecureStore(
                  flutterSecureStorage: FlutterSecureStorage()),
            ),
            ProxyProvider2<AuthService, EmailSecureStore, FirebaseLinkHandler>(
              lazy: false,
              update: (BuildContext context, AuthService authService,
                      // Firebase Dynamic Links are not supported on the web at the moment
                      EmailSecureStore storage, __) =>
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
            );
            },
          ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    Logger.root.info("Received onResume message");
    Logger.root.info(message);
    // Android notifications are handled in java code
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        presentSound: true, sound: "school_fire_alarm");
    var platformChannelSpecifics =
    NotificationDetails(iOS:iOSPlatformChannelSpecifics);
    await FlutterLocalNotificationsPlugin().show(0, message.data["description"],
        message.data["needForAction"], platformChannelSpecifics);
}
