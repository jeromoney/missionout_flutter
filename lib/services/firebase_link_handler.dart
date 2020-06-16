import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:missionout/data_objects/is_loading_notifier.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

import 'email_secure_store.dart';

class FirebaseLinkHandler {
  final _logger = Logger("FirebaseLinkHandler");
  final AuthService auth;
  final EmailSecureStore emailStore;
  final BuildContext context;

  FirebaseLinkHandler(
      {Key key, @required this.auth, @required this.emailStore, @required this.context}) {
    _initDynamicLinks();
  }

  void _initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) _signInWithEmail(deepLink.toString());
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri link = dynamicLink?.link;
      if (link != null) _signInWithEmail(dynamicLink.toString());
    }, onError: (OnLinkErrorException e) async {
      _logger.warning("Error processing firebase link", e);
    });
  }

  Future<void> _signInWithEmail(String link) async {
    final isLoadingProvider = Provider.of<IsLoadingNotifier>(context,listen: false);
    try {
      isLoadingProvider.isLoading = true;
      // check that user is not signed in
      final User user = await auth.currentUser();
      if (user != null) {
        _logger.warning("User is already signed in");
        return;
      }
      // check that email is set
      final email = await emailStore.getEmail();
      if (email == null) {
        _logger.warning("Email not set");
        return;
      }
      // sign in
      if (await auth.isSignInWithEmailLink(link)) {
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
      );
    } on PlatformException catch (e) {
      rethrow;
    }
  }
}
