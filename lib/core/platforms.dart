import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
// dart:io is not supported by web so building out own class
// Since Platform can crash an web app, I'm moving all the calls to this file

enum Operating_Systems { Web, Android, IOS }

bool get isWeb => kIsWeb;

bool get isAndroid {
  if (isWeb) return false;
  return Platform.isAndroid;
}

bool get isIOS {
  if (isWeb) return false;
  return Platform.isIOS;
}

bool get isMacOS {
  if (isWeb) return false;
  return Platform.isMacOS;
}
