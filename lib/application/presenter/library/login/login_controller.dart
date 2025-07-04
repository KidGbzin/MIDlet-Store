part of '../login/login_handler.dart';

class _Controller {
  
  /// Manages Firebase Cloud Messaging operations, including notification handling and token management.
  final FirebaseMessagingService sFirebaseMessaging;

  /// Manages Google authentication flows, including silent sign-in and explicit sign-in requests.
  final GoogleOAuthService sGoogleOAuth;

  /// Manages Supabase authentication and database services, handling user sessions and data synchronization.
  final SupabaseService sSupabase;

  _Controller({
    required this.sFirebaseMessaging,
    required this.sGoogleOAuth,
    required this.sSupabase,
  });

  late final ValueNotifier<Progresses> nProgress;

  /// Initializes the handler’s core services and state notifiers.
  ///
  /// This method must be called from the `initState` of the handler widget.
  /// It prepares essential services and, if necessary, manages the initial navigation flow based on the current application state.
  Future<void> initialize(BuildContext context) async {
    nProgress = ValueNotifier(Progresses.isLoading);

    try {
      final bool hasCachedSession = await _hasCachedSession();

      if (hasCachedSession) {
        await sFirebaseMessaging.registerToken();

        nProgress.value = Progresses.isFinished;

        return;
      }

      nProgress.value = Progresses.requestSignIn;
    }
    catch (error, stackTrace) {
      nProgress.value = Progresses.hasError;
      
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );
    }
  }

  /// Disposes the handler’s resources and notifiers.
  ///
  /// This method must be called from the `dispose` method of the handler widget to ensure proper cleanup and prevent memory leaks.
  void dispose() => nProgress.dispose();

  /// Attempts to restore a cached user session via silent Google Sign-In.
  ///
  /// Returns `true` if a valid session is found and the user is successfully logged into Supabase.
  /// Returns `false` if no session is found or if an error occurs during the sign-in process.
  ///
  /// This method can be used to determine whether to proceed with automatic login or prompt the user to sign in manually.
  Future<bool> _hasCachedSession() async {
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
  /// If the sign-in is successful, navigates to the `Search` view.
  /// If the sign-in is cancelled or fails, the error is logged.
  ///
  /// This method requires a [BuildContext] to perform navigation upon successful login.
  Future<void> googleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAuthentication? authentication = await sGoogleOAuth.signIn();

      if (authentication == null) return;

      await sSupabase.loginWithGoogle(
        idToken: authentication.idToken!,
        accessToken: authentication.accessToken,
      );

      await sFirebaseMessaging.registerToken();

      nProgress.value = Progresses.isFinished;
    }
    catch (error, stackTrace) {
      nProgress.value = Progresses.hasError;

      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );
    }
  }

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