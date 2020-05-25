import 'package:flutter/material.dart';
import 'package:missionout/data_objects/is_loading_notifier.dart';
import 'package:missionout/app/sign_in/sign_in_manager.dart';
import 'package:missionout/app/sign_in/welcome_screen.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

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
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => WelcomeScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
        },
      ),
    );
  }
}
