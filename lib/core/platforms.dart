import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
// dart:io is not supported by web so building out own class

enum Operating_Systems { Web, Android, IOS }

class Platforms {
  static bool get isWeb => kIsWeb;

  static bool get isAndroid {
    try {
      return Platform.isAndroid;
    } on Exception {
      return false;
    }
  }

  static bool get isIOS {
    try {
      return Platform.isIOS;
    } on Exception  {
      return false;
    }
  }

  static bool get isMacOS {
    try {
      return Platform.isMacOS;
    } on Exception {
      return false;
    }
  }
}
