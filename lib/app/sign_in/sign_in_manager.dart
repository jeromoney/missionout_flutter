import 'package:flutter/foundation.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/user/user.dart';

class SignInManager {
  final AuthService authService;
  final ValueNotifier<bool> isLoading;

  SignInManager({@required this.authService, @required this.isLoading});

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
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
