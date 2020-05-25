import 'package:apple_sign_in/apple_sign_in.dart';

// A simple class to determine whether Apple Sign In is available. This could just
// be a boolean, but this could trip up a provider tree search if a second boolean
// were to be added.
class AppleSignInAvailable {
  final bool isAvailable;

  const AppleSignInAvailable({this.isAvailable});

  static Future<AppleSignInAvailable> check() async =>
      AppleSignInAvailable(isAvailable: await AppleSignIn.isAvailable());
}
