part of '../login/login_handler.dart';

enum _States {
  requestSignIn,
  isLoading,
  isReady,
  noProfile,
}

class _Controller implements IController {

  /// Handles main database interactions, including fetching and updating game data, ratings, and related metadata.
  final SupabaseRepository rSupabase;
  
  /// Manages Firebase Cloud Messaging operations, including notification handling and token management.
  final FirebaseMessagingService sFirebaseMessaging;

  /// Manages Google authentication flows, including silent sign-in and explicit sign-in requests.
  final GoogleOAuthService sGoogleOAuth;

  /// Manages Supabase authentication and database services, handling user sessions and data synchronization.
  final SupabaseService sSupabase;

  _Controller({
    required this.rSupabase,
    required this.sFirebaseMessaging,
    required this.sGoogleOAuth,
    required this.sSupabase,
  });

  @override
  void dispose() {
    nProgress.dispose();
  }

  @override
  Future<void> initialize() async {
    try {
      final bool hasCachedSession = await _hasCachedSession();

      if (hasCachedSession) {
        await sFirebaseMessaging.registerToken();

        nProgress.value = (
          state: Progresses.isReady,
          error: null,
        );

        return;
      }

      nProgress.value = (
        state: Progresses.isReady,
        error: null,
      );
      nLoginState.value = (
        state: _States.requestSignIn,
        error: null,
      );
    }
    catch (error, stackTrace) {
      nProgress.value = (
        state: Progresses.hasError,
        error: error,
      );
      
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );
    }
  }

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Notifiers ⮟

  final ValueNotifier<({
    Progresses state,
    Object? error,
  })> nProgress = ValueNotifier((
    state: Progresses.isLoading,
    error: null,
  ));

  final ValueNotifier<({
    _States state,
    Object? error,
  })> nLoginState = ValueNotifier((
    state: _States.isLoading,
    error: null,
  ));

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Profile ⮟

  Future<void> checkProfile() async {
    try {
      await rSupabase.getProfileForUser(null);

      nLoginState.value = (
        state: _States.isReady,
        error: null,
      );
    }
    on PostgrestException catch (_) {
      nLoginState.value = (
        state: _States.noProfile,
        error: null,
      );
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );
    }
  }

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Login ⮟

  /// Attempts to restore a cached user session via silent Google Sign-In.
  ///
  /// Returns `true` if a valid session is found and the user is successfully logged into Supabase.
  /// Returns `false` if no session is found or if an error occurs during the sign-in process.
  ///
  /// This method can be used to determine whether to proceed with automatic login or prompt the user to sign in manually.
  Future<bool> _hasCachedSession() async {
    if (kDebugMode) return false;

    final GoogleSignInAuthentication? googleSignInAuthentication = await sGoogleOAuth.signInSilently();
      
    if (googleSignInAuthentication != null) {
      await sSupabase.loginWithGoogle(
        idToken: googleSignInAuthentication.idToken!,
        accessToken: googleSignInAuthentication.accessToken,
      );
    
      return true;
    }
    return false;
  }

  /// Initiates the manual Google Sign-In flow and logs the user into Supabase.
  ///
  /// If the sign-in is successful, navigates to the `Home` view.
  /// If the sign-in is cancelled or fails, the error is logged.
  ///
  /// This method requires a [BuildContext] to perform navigation upon successful login.
  Future<void> googleSignIn(BuildContext context) async {
    try {
      nLoginState.value = (state: _States.isLoading, error: null);

      final GoogleSignInAuthentication? authentication = await sGoogleOAuth.signIn();

      if (authentication == null) return;

      await sSupabase.loginWithGoogle(
        idToken: authentication.idToken!,
        accessToken: authentication.accessToken,
      );

      await sFirebaseMessaging.registerToken();

      nLoginState.value = (state: _States.isReady, error: null);
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );
    }
  }

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Notifications ⮟
  void handleNotificationMessage(BuildContext context) {
    try {
      final RemoteMessage? message = sFirebaseMessaging.message;
  
      if (message == null) {
        Logger.information("There's no notification message to handle, opening the default Search view.");

        context.gtHome(
          replace: true,
        );

        return;
      }

      final String? title = message.data["Game-Title"];

      if (title != null) {
        // TODO: Change the notification type to ID to show the game details.
        
        context.gtHome(
          replace: true,
        );

        return;
      }

      throw Exception("The notification message includes data that has not been handled.\n${message.data}");
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      context.gtSearch(
        replace: true,
      );
    }
    finally {
      sFirebaseMessaging.clearNotificationMessage();
    }
  }
}