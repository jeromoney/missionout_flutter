import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:missionout/services/apple_sign_in_available.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/firebase_link_handler.dart';
import 'package:provider/provider.dart';


import '../sign_in_manager.dart';

class SignUpScreenModel{
  final BuildContext context;
  final AppleSignInAvailable _appleSignInAvailable;
  final SignInManager _signInManager;
  final AuthService _authService;
  final FirebaseLinkHandler _linkHandler;
  final _log = Logger('SignUpScreenModel');

  SignUpScreenModel(this.context)
      : this._appleSignInAvailable = context.watch<AppleSignInAvailable>(),
        this._signInManager = context.watch<SignInManager>(),
        this._authService = context.watch<AuthService>(),
        this._linkHandler = context.watch<FirebaseLinkHandler>();

  bool get isAppleSignInAvailable => _appleSignInAvailable.isAvailable;

}