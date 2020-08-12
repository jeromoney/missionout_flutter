import 'package:apple_sign_in/scope.dart';
import 'package:meta/meta.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';

abstract class AuthService {
  Future<User> currentUser();

  Future<User> signInWithEmailAndLink({String email, String link});
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<bool> isSignInWithEmailLink(String link);
  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleID,
    @required String androidPackageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
    bool userMustExist = false,
  });


  Future<User> signInWithGoogle();
  Future<User> signInWithApple();
  Future<User> signInWithDemo();


  Future<void> signOut();

  Stream<User> get onAuthStateChanged;
  Future<Team> createTeam();

  void dispose();

}
