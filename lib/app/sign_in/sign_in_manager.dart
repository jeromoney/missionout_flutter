import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:missionout/data_objects/is_loading_notifier.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/user/user.dart';

class SignInManager {
  final AuthService authService;
  final IsLoadingNotifier isLoadingNotifier;
  final _log = Logger('SignInManager');

  SignInManager({@required this.authService, @required this.isLoadingNotifier});

  // ignore: missing_return
  Future<User> _signIn(Future<User> Function({String googleHostedDomain}) signInMethod, {String googleHostedDomain}) async {
    isLoadingNotifier.isLoading = true;
    try {
      final User user = await signInMethod(googleHostedDomain: googleHostedDomain);
      isLoadingNotifier.isLoading = false;
      return user;
    } on PlatformException catch (e) {
      isLoadingNotifier.isLoading = false;
      _log.warning('Unable to complete sign in process', e);
    } on auth.FirebaseAuthException {
      // User signed in but has not been assigned a team yet
      isLoadingNotifier.isLoading = false;
      rethrow;
    } catch (e) {
      isLoadingNotifier.isLoading = false;
      rethrow;
    }
  }

  Future signInWithGoogle({String googleHostedDomain}) async {
    try {
      await _signIn(authService.signInWithGoogle, googleHostedDomain: googleHostedDomain);
    } on auth.FirebaseAuthException {
      final googleSignIn = GoogleSignIn();
      googleSignIn.disconnect();
      isLoadingNotifier.isLoading = false;
      rethrow;
    }
  }

  Future signInWithApple() async {
    return await _signIn(authService.signInWithApple);
  }
}
