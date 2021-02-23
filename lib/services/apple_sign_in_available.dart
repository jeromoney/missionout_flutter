import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// A simple class to determine whether Apple Sign In is available. This could just
// be a boolean, but this could trip up a provider tree search if a second boolean
// were to be added.
class AppleSignInAvailable {
  final BuildContext context;
   AppleSignInAvailable(this.context);
  bool get isAvailable => Theme.of(context).platform == TargetPlatform.iOS;
}
