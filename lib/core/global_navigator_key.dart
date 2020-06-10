import 'package:flutter/material.dart';

/// Holds the navigation key of the current material app. Used so widgets that
/// are above the widget tree can access show alerts
class GlobalNavigatorKey {
  GlobalKey<NavigatorState> navKey;
}
