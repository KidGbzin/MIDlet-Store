import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for managing interactions with Supabase, including initialization, authentication, and session management.  
///
/// This service abstracts Supabase operations, providing:  
/// - **Initialization**: Configures the Supabase client for backend communication.  
/// - **Authentication**: Handles user login exclusively via Google OAuth.  
///
/// Utilizes the [`supabase_flutter`](https://pub.dev/packages/supabase_flutter) package.
class SupabaseService {

  /// Provides direct access to the Supabase client for database interactions.
  SupabaseClient get client => Supabase.instance.client;

  /// Retrieves the current session for the authenticated user.
  /// 
  /// This session provides information about the user's authentication state.
  String get currentUserID => Supabase.instance.client.auth.currentUser!.id;
  
  /// Initializes the Supabase client with the provided credentials.
  /// 
  /// This method configures the Supabase client to interact with the backend using the provided API keys and URL.
  Future<void> initialize() async {
    Supabase.initialize(
      anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
      url: const String.fromEnvironment('SUPABASE_URL')
    );
  }

  /// Logs in a user using Google authentication with the provided tokens.
  /// 
  /// This method uses the provided [accessToken] and [idToken] to authenticate the user with Google and returns a session upon success.
  Future<void> loginWithGoogle({
    required String? accessToken,
    required String idToken,
  }) async {
    Supabase.instance.client.auth.signInWithIdToken(
      accessToken: accessToken,
      idToken: idToken,
      provider: OAuthProvider.google,
    );
  }
}