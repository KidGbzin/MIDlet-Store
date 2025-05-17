import 'package:supabase_flutter/supabase_flutter.dart';

import '../../logger.dart';

/// Service for managing interactions with Supabase, including initialization, authentication, and session management.  
///
/// This service abstracts Supabase operations, providing:  
/// - **Initialization**: Configures the Supabase client for backend communication.  
/// - **Authentication**: Handles user login exclusively via Google OAuth.  
///
/// Utilizes the [supabase_flutter](https://pub.dev/packages/supabase_flutter) package.
class SupabaseService {

  SupabaseService({
    required this.anonKey,
    required this.url,
  }) : assert(
    anonKey.isNotEmpty,
    url.isNotEmpty,
  );

  final String anonKey;
  final String url;

  /// Provides direct access to the Supabase client for database interactions.
  SupabaseClient get client => Supabase.instance.client;

  /// Retrieves the current session for the authenticated user.
  /// 
  /// This session provides information about the user's authentication state.
  String get currentUserID => Supabase.instance.client.auth.currentUser!.id;
  
  /// Initializes the Supabase client with the provided credentials.
  ///
  /// Configures the Supabase client to communicate with the backend using the provided [anonKey] and [url].
  /// The client must be initialized before interacting with the Supabase services.
  Future<void> initialize() async {
    Logger.information("Initializing the Supabase service...");

    await Supabase.initialize(
      anonKey: anonKey,
      url: url,
    );
  }

  /// Logs in a user using Google authentication with the provided tokens.
  ///
  /// This method uses the provided [accessToken] and [idToken] to authenticate the user with Google. 
  /// Upon success, the user's session is returned, granting access to authenticated services.
  /// 
  /// Throws:
  /// - `AuthException`: Thrown if Supabase could not authenticate the user with the provided Google credentials.
  Future<void> loginWithGoogle({
    required String? accessToken,
    required String idToken,
  }) async {
    final AuthResponse response = await Supabase.instance.client.auth.signInWithIdToken(
      accessToken: accessToken,
      idToken: idToken,
      provider: OAuthProvider.google,
    );

    Logger.success('Successfully authenticated in the Supabase as ${response.session!.user.userMetadata!["name"]} via Google OAuth.');
  }
}