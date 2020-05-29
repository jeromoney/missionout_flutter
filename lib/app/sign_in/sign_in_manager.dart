import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/user/user.dart';

class SignInManager {
  final AuthService authService;
  final ValueNotifier<bool> isLoading;
  final _log = Logger('SignInManager');

  SignInManager({@required this.authService, @required this.isLoading});

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } on PlatformException catch (e){
      isLoading.value = false;
      _log.warning('Unable to complete sign in process', e);
    }
    catch (e) {
      isLoading.value = false;
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
