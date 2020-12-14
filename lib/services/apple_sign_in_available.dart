import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

// A simple class to determine whether Apple Sign In is available. This could just
// be a boolean, but this could trip up a provider tree search if a second boolean
// were to be added.
class AppleSignInAvailable {
  final bool isAvailable;

  const AppleSignInAvailable({this.isAvailable});

  static AppleSignInAvailable check()  {
    if (kIsWeb) return AppleSignInAvailable(isAvailable: false);
    else return AppleSignInAvailable(isAvailable: Platform.isIOS);
  }
}
