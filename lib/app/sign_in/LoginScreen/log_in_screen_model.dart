import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:missionout/app/sign_in/sign_in_manager.dart';
import 'package:missionout/common_widgets/platform_alert_dialog.dart';
import 'package:missionout/common_widgets/platform_exception_alert_dialog.dart';
import 'package:missionout/constants/constants.dart';
import 'package:missionout/constants/strings.dart';
import 'package:missionout/core/platforms.dart';
import 'package:missionout/services/apple_sign_in_available.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/email_secure_store.dart';
import 'package:missionout/services/firebase_link_handler.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class LoginScreenModel {
  final BuildContext context;
  final AppleSignInAvailable _appleSignInAvailable;
  final SignInManager _signInManager;
  final AuthService _authService;
  final FirebaseLinkHandler _linkHandler;
  final _log = Logger('LogInScreenModel');

  LoginScreenModel(this.context)
      : _appleSignInAvailable = context.watch<AppleSignInAvailable>(),
        _signInManager = context.watch<SignInManager>(),
        _authService = context.watch<AuthService>(),
        _linkHandler = context.watch<FirebaseLinkHandler>();

  bool get isAppleSignInAvailable => _appleSignInAvailable.isAvailable;

  Future _signIn(Future Function({String googleHostedDomain}) signInMethod,
      {String googleHostedDomain}) async {
    try {
      await signInMethod(googleHostedDomain: googleHostedDomain);
    } on FirebaseAuthException {
      PlatformAlertDialog(
        title: "Team is not yet assigned",
        content: "Try another account or contact your team administrator",
        defaultActionText: Strings.ok,
      ).show(context);
    }
  }

  Future signInWithGoogle({String hostedDomain}) async =>
      _signIn(_signInManager.signInWithGoogle,
          googleHostedDomain: hostedDomain);

  Future signInWithApple({String hostedDomain}) async =>
      _signIn(_signInManager.signInWithApple);

  Future<String> getEmail() async {
    // Method is called in init method with a different context, so slightly
    // different style
    final emailSecureStore = context.read<EmailSecureStore>();
    final log = Logger('LogInScreenModel getEmail method');
    return emailSecureStore?.getEmail()?.catchError((e) {
      log.warning("Error retrieving saved email: $e");
    });
  }

  Future signInWithEmailAndPassword(String email, String password) async =>
      _authService.signInWithEmailAndPassword(email, password);

  Future sendEmailLink({@required String email}) async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      // Send link
      try {
        await _linkHandler.sendSignInWithEmailLink(
            email: email,
            url: Constants.firebaseProjectURl,
            handleCodeInApp: true,
            packageName: packageInfo.packageName,
            androidInstallIfNotAvailable: true,
            androidMinimumVersion: '18',
            userMustExist: true);
      } on StateError {
        _log.warning("user entered an email that is not in database");
        PlatformAlertDialog(
          title: "Email not in database",
          content: "$email is not in database. Use the sign up option instead",
          defaultActionText: Strings.ok,
        ).show(context);
        return;
      }

      // Tell user we sent an email
      PlatformAlertDialog(
        title: Strings.checkYourEmail,
        content: Strings.activationLinkSent(email),
        defaultActionText: Strings.ok,
      ).show(context);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: Strings.errorSendingEmail,
        exception: e,
      ).show(context);
    }
  }

  // Apple Setup - Show Apple button only if iOS and running 13 or later. Since
  // this method is async it needs to be used with a future builder
  Future<bool> isCorrectIosVersion() async {
    if (isIOS) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      final systemVersion = iosInfo.systemVersion;
      return systemVersion.startsWith(RegExp("1[3,4,5,6,7,8,9]\."));
    }
    return false;
  }
}
