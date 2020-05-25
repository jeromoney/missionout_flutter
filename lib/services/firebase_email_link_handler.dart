import 'package:flutter/widgets.dart';
import 'package:missionout/services/auth_service/auth_service.dart';
import 'package:missionout/services/email_secure_store.dart';

class FirebaseEmailLinkHandler with WidgetsBindingObserver {
  final AuthService auth;
  final WidgetsBinding widgetsBinding;
  final EmailSecureStore emailStore;

  FirebaseEmailLinkHandler(
      {@required this.auth, @required this.widgetsBinding, @required this.emailStore}) {
    // Add observer so app can detect when resumes
    widgetsBinding.addObserver(this);
  }


  static FirebaseEmailLinkHandler createAndConfigure(
      {@required AuthService auth, @required EmailSecureStore userCredentialsStorage}) {
    final linkHandler = FirebaseEmailLinkHandler(auth: auth, widgetsBinding: WidgetsBinding.instance, emailStore: userCredentialsStorage);
    throw UnimplementedError();
  }

  void dispose() {
    widgetsBinding.removeObserver(this);
  }

}
