import 'package:google_sign_in/google_sign_in.dart';

import '../core/enumerations/logger_enumeration.dart';

/// A service for handling user authentication via Google Sign-In.
///
/// This service provides methods for signing in and out of the application using Google Sign-In.
/// It also provides a method for signing in silently, which will automatically log the user in
/// if they have previously signed in.
class AuthenticationService {

  /// The `GoogleSignIn` client used for authentication.
  final GoogleSignIn _client = GoogleSignIn(
    serverClientId: const String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID'),
  );

  /// The `GoogleSignIn` client used for authentication.
  GoogleSignIn get client => _client; 

  /// Signs in the user using Google Sign-In.
  ///
  /// If the user is successfully signed in, a [GoogleSignInAuthentication] object is returned.
  /// If the user is not signed in, `null` is returned.
  Future<GoogleSignInAuthentication?> signIn() async {
    final GoogleSignInAccount? account = await _client.signIn();
    if (account != null) {
      Logger.success.print(
        message: 'Successfully logged in as ${account.displayName}.',
        label: 'Authentication | Google Sign In',
      );
      return account.authentication;
    }
    return null;
  }

  /// Signs in the user silently using Google Sign-In.
  ///
  /// If the user is successfully signed in, a [GoogleSignInAuthentication] object is returned.
  /// If the user is not signed in, `null` is returned.
  Future<GoogleSignInAuthentication?> signInSilently() async {
    final GoogleSignInAccount? account = await _client.signInSilently();
    if (account != null) {
      Logger.success.print(
        message: 'Successfully logged in as ${account.displayName}.',
        label: 'Authentication | Google Sign In Silently',
      );
      return account.authentication;
    }
    return null;
  }

  /// Signs out the user from the application.
  ///
  /// This method signs out the user from the application and removes any authentication tokens.
  Future<void> signOut() => _client.signOut();
}
