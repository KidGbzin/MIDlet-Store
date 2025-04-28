import 'package:google_sign_in/google_sign_in.dart';

import '../core/enumerations/logger_enumeration.dart';

/// A service for handling user authentication via Google Sign-In.
///
/// This service provides methods for signing in and out of the application using Google Sign-In.
/// It also provides a method for signing in silently, which will automatically log the user in if they have previously signed in.
///
/// Utilizes the [google_sign_in](https://pub.dev/packages/google_sign_in) package.
class GoogleOAuthService {

  GoogleOAuthService(this.identifier) : assert(identifier.isNotEmpty);

  /// The server client ID used for Google authentication.
  ///
  /// This unique identifier is required to authenticate the user via Google Sign-In.
  /// You can find this ID in the [Google Cloud Console](https://console.cloud.google.com/), under your project’s OAuth 2.0 credentials.
  final String identifier;

  /// The `GoogleSignIn` client used for authentication.
  late final GoogleSignIn _client = GoogleSignIn(
    serverClientId: identifier,
  );

  /// Signs in the user using Google Sign-In.
  ///
  /// Returns the [GoogleSignInAuthentication] if the sign-in is successful, or `null` if the user cancels.
  Future<GoogleSignInAuthentication?> signIn() async {
    try {
      final GoogleSignInAccount? account = await _client.signIn();

      if (account != null) {
        Logger.success.log("Successfully signed in as ${account.displayName}.");

        return account.authentication;
      }
      else {
        Logger.warning.log("The user canceled the Google Sign-In.");
      }
    }
    catch (error, stackTrace) {
      Logger.error.log(
        "$error",
        stackTrace: stackTrace,
      );
    }

    return null;
  }

  /// Signs in the user silently using Google Sign-In.
  ///
  /// Returns the [GoogleSignInAuthentication] if successful, or `null` if no user session is available.
  Future<GoogleSignInAuthentication?> signInSilently() async {
    try {
      final GoogleSignInAccount? account = await _client.signInSilently();

      if (account != null) {
        Logger.success.log("Successfully signed in silently as ${account.displayName} via Google OAuth.");

        return account.authentication;
      }
      else {
        Logger.warning.log("There is no active user session found for silent sign-in.");
      }
    }
    catch (error, stackTrace) {
      Logger.error.log(
        "$error",
        stackTrace: stackTrace,
      );
    }

    return null;
  }

  /// Signs out the user from the application.
  ///
  /// Removes any stored authentication tokens and user session.
  Future<void> signOut() async {
    try {
      await _client.signOut();
      Logger.information.print(
        label: 'Google OAuth Service',
        message: 'User signed out successfully.',
      );
    }
    catch (error, stackTrace) {
      Logger.error.print(
        label: 'Google OAuth Service',
        message: 'Sign-out failed: $error',
        stackTrace: stackTrace,
      );
    }
  }
}