import 'package:flutter/material.dart';

abstract class PlatformWidget extends StatelessWidget {
  Widget buildCupertinoWidget(BuildContext context);

  Widget buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    // This code is a bit risky. Platforms.isIOS will trigger an exception in web
    // , but it should be caught by Platforms.
    if (Theme.of(context).platform == TargetPlatform.iOS) return buildCupertinoWidget(context);
    return buildMaterialWidget(context);
  }
}
