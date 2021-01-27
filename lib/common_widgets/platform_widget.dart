import 'package:flutter/material.dart';
import 'package:missionout/core/platforms.dart';

abstract class PlatformWidget extends StatelessWidget {
  Widget buildCupertinoWidget(BuildContext context);

  Widget buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    // This code is a bit risky. Platforms.isIOS will trigger an exception in web
    // , but it should be caught by Platforms.
    if (isIOS) return buildCupertinoWidget(context);
    return buildMaterialWidget(context);
  }
}
