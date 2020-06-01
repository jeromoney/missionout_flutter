import 'package:flutter/material.dart';
import 'package:missionout/app/sign_in/log_in_screen.dart';
import 'package:missionout/app/sign_in/team_domain_screen.dart';
import 'package:missionout/data_objects/is_loading_notifier.dart';
import 'package:missionout/app/sign_in/sign_in_manager.dart';
import 'package:missionout/app/sign_in/welcome_screen.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/firebase_email_link_handler.dart';
import 'package:provider/provider.dart';

import 'sign_up_screen.dart';

class SigninApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<IsLoadingNotifier>(
          create: (_) => IsLoadingNotifier(),
        ),
        ProxyProvider<IsLoadingNotifier, SignInManager>(
            create: (_) => SignInManager(
                authService: authService,
                isLoading: ValueNotifier<bool>(false)),
            update: (_, isLoadingNotifier, signInManager) => SignInManager(
                  authService: authService,
                  isLoading: ValueNotifier<bool>(isLoadingNotifier.isLoading),
                )),
      ],
      child: Builder(
        builder: (context) {
          final linkHandler = Provider.of<FirebaseEmailLinkHandler>(context);
          var i = linkHandler;

          return MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => WelcomeScreen(),
              SignUpScreen.routeName: (context) => SignUpScreen(),
              LogInScreen.routeName: (context) => LogInScreen(),
              TeamDomainScreen.routeName: (context) => TeamDomainScreen(),
            },
            theme: ThemeData(
                textTheme: TextTheme(
                    subtitle2: TextStyle(color: Colors.blue, fontSize: 16.0))),
          );
        },
      ),
    );
  }
}
