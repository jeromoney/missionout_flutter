import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:missionout/app/sign_in/LoginScreen/log_in_screen.dart';
import 'package:missionout/constants/secrets.dart';
import 'package:missionout/core/global_navigator_key.dart';
import 'package:missionout/core/platforms.dart';
import 'package:missionout/data_objects/app_setup.dart';
import 'package:missionout/data_objects/is_loading_notifier.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

import 'email_secure_store.dart';

enum LinkModes { emailSignIn, loginCustomization, initialize }

class FirebaseLinkHandler {
  final _logger = Logger("FirebaseLinkHandler");
  final AuthService auth;
  final EmailSecureStore emailStore;
  final BuildContext context;

  FirebaseLinkHandler(
      {Key key,
      @required this.auth,
      @required this.emailStore,
      @required this.context}) {
    _initDynamicLinks();
  }

  // When app is opened, initializes DynamicLinks for when the app is running and
  // when the app is shut down
  void _initDynamicLinks() async {
    // Web is not supported at the moment
    if (Platforms.isWeb) return;
    final PendingDynamicLinkData dynamicLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    // handle DynamicLinks if the app is already running
    _routeDynamicLinks(dynamicLink);
    // If app is launched with DynamicLink, handle it
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async =>
            _routeDynamicLinks(dynamicLink),
        onError: (OnLinkErrorException e) async {
          _logger.warning("Error processing firebase link", e);
        });
  }

  Future _signInWithEmail(PendingDynamicLinkData dynamicLinkData) async {
    final String link = dynamicLinkData.link.toString();
    final isLoadingProvider = context.read<IsLoadingNotifier>();
    try {
      isLoadingProvider.isLoading = true;
      // check that user is not signed in
      final User user = await auth.currentUser();
      if (user != null) {
        _logger.warning("User is already signed in");
        return;
      }
      // check that email is set
      final email = await emailStore?.getEmail();
      if (email == null) {
        _logger.warning("Email not set");
        return;
      }
      // sign in
      if (auth.isSignInWithEmailLink(link)) {
        await auth.signInWithEmailAndLink(email: email, link: link);
      } else {
        _logger.warning("Link is not sign in with email link");
      }
    } on PlatformException catch (e) {
      _logger.warning("Platform exception: ${e.message}", e);
    } finally {
      isLoadingProvider.isLoading = false;
    }
  }

  // sign in
  Future sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String packageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
    bool userMustExist = false,
  }) async {
    try {
      // Save to email store
      await emailStore.setEmail(email);
      // Send link
      await auth.sendSignInWithEmailLink(
          email: email,
          url: url,
          handleCodeInApp: handleCodeInApp,
          iOSBundleID: packageName,
          androidPackageName: packageName,
          androidInstallIfNotAvailable: androidInstallIfNotAvailable,
          androidMinimumVersion: androidMinimumVersion,
          userMustExist: userMustExist);
    } on PlatformException {
      rethrow;
    }
  }

  Future _signInToDemo() async {
    final isLoadingProvider = context.read<IsLoadingNotifier>();
    try {
      isLoadingProvider.isLoading = true;
      auth.signInWithDemo();
    } finally {
      isLoadingProvider.isLoading = false;
    }
  }

  _routeDynamicLinks(PendingDynamicLinkData data) {
    // Do nothing
    if (data == null) {
      return;
    }
    // Sign into demo for iOS purposes
    if (data.link?.path == Secrets.IOS_PATH) {
      _signInToDemo();
      return;
    }
    // Handle sign in with email link
    if (data.link?.queryParameters["mode"] == "signin") {
      _signInWithEmail(data);
      return;
    }
    // Finally assume link is custom login screen
    final teamDomain = data.link.path.substring(1);
     _loginTeamCustomization(teamDomain);
    return;
  }

  _loginTeamCustomization(String teamDomain) async {
    if (auth.userIsLoggedIn){
      _logger.warning("User is already signed in");
      return;
    }
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final snapshot = await db.doc("app_setup/$teamDomain").get();
    if (!snapshot.exists){
      _logger.warning("Couldn't find setup document for domain: $teamDomain");
      return;
    }
    final appSetup = AppSetup.fromSnapshot(snapshot);
    final navKey = context.read<GlobalNavigatorKey>().navKey;
    Navigator.pushNamed(navKey.currentContext, LogInScreen.routeName, arguments: appSetup);
  }
}
