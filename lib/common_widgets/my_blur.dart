import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const BLUR = 10.0;

class MyBlur extends StatefulWidget {
  final Widget child;

  const MyBlur({Key key, @required this.child}) : super(key: key);

  @override
  _MyBlurState createState() => _MyBlurState();
}

class _MyBlurState extends State<MyBlur> {
  StreamSubscription _subscription;
  bool _isShowOverlay = false;

  @override
  void initState() {
    super.initState();
    _subscription = context
        .read<StreamController<bool>>()
        .stream
        .listen((isShowOverlay) => setState(() {
              _isShowOverlay = isShowOverlay;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return _isShowOverlay
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              context.read<StreamController<bool>>().add(false);
            },
            child: Center(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: BLUR, sigmaX: BLUR),
                  child: widget.child,
                ),
              ),
            ),
          )
        : Container();
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription.cancel();
    super.dispose();
  }
}
