import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:missionout/core/fcm_message_handler.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

import 'package:missionout/services/auth_service/auth_service_adapter.dart';
import 'package:missionout/services/apple_sign_in_available.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/app/auth_widget.dart';
import 'package:missionout/app/auth_widget_builder.dart';
import 'package:missionout/services/email_secure_store.dart';
import 'package:missionout/services/firebase_email_link_handler.dart';


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
  static final navKey = GlobalKey<
      NavigatorState>(); // Passes context to widgets above MaterialApp
  final AuthServiceType initialAuthServiceType;
  final AppleSignInAvailable appleSignInAvailable;

  const MyApp(
      {this.initialAuthServiceType = AuthServiceType.firebase,
      this.appleSignInAvailable});

  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            Provider<AppleSignInAvailable>(
              create: (_) => appleSignInAvailable,
            ),
            Provider<AuthService>(
              create: (_) => AuthServiceAdapter(
                  initialAuthServiceType: initialAuthServiceType),
              dispose: (_, AuthService authService) => authService.dispose(),
            ),
            Provider<EmailSecureStore>(
              create: (_) => EmailSecureStore(
                  flutterSecureStorage: FlutterSecureStorage()),
            ),
            ProxyProvider2<AuthService, EmailSecureStore,
                FirebaseEmailLinkHandler>(
              update:
                  (_, AuthService authService, EmailSecureStore storage, __) =>
                      FirebaseEmailLinkHandler.createAndConfigure(
                auth: authService,
                userCredentialsStorage: storage,
              ),
              dispose: (_, linkHandler) => linkHandler.dispose(),
            ),
          ],
          child: FCMMessageHandler(
            child: AuthWidgetBuilder(
              builder:
                  (BuildContext context, AsyncSnapshot<User> userSnapshot) =>
                      AuthWidget(
                userSnapshot: userSnapshot,
              ),
            ),
          ));
}
