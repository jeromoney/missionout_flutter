import 'package:flutter/foundation.dart';

class Strings {
  static const appName = 'MissionOut';

  // Android Channel Information
  static const channelId ='mission_pages';
  static const channelName = 'Mission Pages';
  static const channelDescription = 'This channel is used to page out missions.';

  // Generic strings
  static const ok = 'OK';
  static const cancel = 'Cancel';

  // Logout
  static const logout = 'Logout';
  static const logoutAreYouSure =
      'Are you sure that you want to logout?';
  static const logoutFailed = 'Logout failed';

  // Sign In Page
  static const signIn = 'Sign in';
  static const signInWithEmailPassword =
      'Sign in with email and password';
  static const signInWithEmailLink = 'Sign in with email link';
  static const signInWithFacebook = 'Sign in with Facebook';
  static const signInWithGoogle = 'Sign in with Google';
  static const goAnonymous = 'Go anonymous';
  static const or = 'or';

  // Email & Password page
  static const register = 'Register';
  static const forgotPassword = 'Forgot password';
  static const forgotPasswordQuestion = 'Forgot password?';
  static const createAnAccount = 'Create an account';
  static const needAnAccount = 'Need an account? Register';
  static const haveAnAccount = 'Have an account? Sign in';
  static const signInFailed = 'Sign in failed';
  static const registrationFailed = 'Registration failed';
  static const passwordResetFailed = 'Password reset failed';
  static const sendResetLink = 'Send Reset Link';
  static const backToSignIn = 'Back to sign in';
  static const resetLinkSentTitle = 'Reset link sent';
  static const resetLinkSentMessage =
      'Check your email to reset your password';
  static const emailLabel = 'Email';
  static const emailHint = 'test@test.com';
  static const password8CharactersLabel = 'Password (8+ characters)';
  static const passwordLabel = 'Password';
  static const invalidEmailErrorText = 'Email is invalid';
  static const invalidEmailEmpty = "Email can't be empty";
  static const invalidPasswordTooShort = 'Password is too short';
  static const invalidPasswordEmpty = "Password can't be empty";

  // Email link page
  static const submitEmailAddressLink =
      'Submit your email address to receive an activation link.';
  static const checkYourEmail = 'Check your email';

  static String activationLinkSent(email) =>
      'We have sent an activation link to $email';
  static const errorSendingEmail = 'Error sending email';
  static const sendActivationLink = 'Send activation link';
  static const activationLinkError = 'Email activation error';
  static const submitEmailAgain =
      'Please submit your email address again to receive a new activation link.';
  static const userAlreadySignedIn =
      'Received an activation link but you are already signed in.';
  static const isNotSignInWithEmailLinkMessage =
      'Invalid activation link';

  // Home page
  static const homePage = 'Home Page';

  // Developer menu
  static const developerMenu = 'Developer menu';
  static const authenticationType = 'Authentication type';
  static const firebase = 'Firebase';
  static const mock = 'Mock';

  // General Error Message
  static const errorMessage = 'Some error occurred';

  // Detail Page
  static const pageTeam = 'Page Team';
  static const pageTeamQuestion = 'Page Team?';
  static const pageTeamConsequence = 'The entire team will be alerted.';

  // User Screen
  static const userScreenTitle = 'Profile';
  static const phoneNumberError =
      'Please correct errors in phone numbers';
  static const submit = 'Submit';
  static const anonymousName = 'anonymous';
  static const anonymousEmail = 'unknown email';
  static const errorPhoneSubmission =
      'Error occurred while submitting phone number.';
  static const androidDNDInfoTitle = "Android info";
  static const androidDNDInfo = """
            On Android devices, Override Do Not Disturb is granted through the system Settings. Search for your phone model for specific directions.
            
            In general, the setting will be located Settings >> Apps & Notification >> Notifications >> MissionOut >> Mission Pages >> Advanced >> Override Do Not Disturb
            """;


}
