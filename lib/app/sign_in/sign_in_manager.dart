import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:missionout/data_objects/is_loading_notifier.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/user/user.dart';

class SignInManager {
  final AuthService authService;
  final IsLoadingNotifier isLoadingNotifier;
  final _log = Logger('SignInManager');

  SignInManager({@required this.authService, @required this.isLoadingNotifier});

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    isLoadingNotifier.isLoading = true;
    try {
      final User user = await signInMethod();
      isLoadingNotifier.isLoading = false;
      return user;
    } on PlatformException catch (e) {
      isLoadingNotifier.isLoading = false;
      _log.warning('Unable to complete sign in process', e);
    } catch (e) {
      isLoadingNotifier.isLoading = false;
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    return await _signIn(authService.signInWithGoogle);
  }

  Future<void> signInWithApple() async {
    return await _signIn(authService.signInWithApple);
  }
}
