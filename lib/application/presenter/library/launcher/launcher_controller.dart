part of '../launcher/launcher_handler.dart';

/// Controls the initialization and authentication flow of the [Launcher] view.
///
/// This controller handles service setup, session restoration, and user authentication management.
class _Controller {
  
  _Controller({
    required this.rHive,
    required this.sActivity,
    required this.sGoogleOAuth,
    required this.sGitHub,
    required this.sSupabase,
  });

  /// Manages local storage operations, including games, favorites, recent games, and cached requests.
  final HiveRepository rHive;

  /// Provides access to native Android activity functions, such as opening URLs or interacting with platform features.
  final ActivityService sActivity;

  /// Handles interactions with the GitHub API, such as fetching remote files and checking for application updates.
  final GitHubService sGitHub;

  /// Manages Google authentication flows, including silent sign-in and explicit sign-in requests.
  final GoogleOAuthService sGoogleOAuth;

  /// Manages Supabase authentication and database services, handling user sessions and data synchronization.
  final SupabaseService sSupabase;

  /// A notifier that holds and updates the current progress state of the launcher flow.
  ///
  /// The state can be one of the values from [ProgressEnumeration], such as loading, login request, success, error, or outdated version.
  late final ValueNotifier<ProgressEnumeration> nProgress;

  /// Initializes application services, checks for updates, and attempts to restore a cached user session.
  ///
  /// Updates the [nProgress] state based on the initialization outcome.
  Future<void> initialize(BuildContext context) async {
    Logger.information.log("Initializing the Launcher controller...");

    nProgress = ValueNotifier<ProgressEnumeration>(ProgressEnumeration.loading);

    try {
      await rHive.initialize();
      await sSupabase.initialize();

      final bool isOutdated = await sGitHub.isVersionOutdated();

      nProgress.value = isOutdated 
          ? ProgressEnumeration.isOutdated 
          : await _findCachedSession();
    } 
    catch (error, stackTrace) {
      nProgress.value = ProgressEnumeration.error;

      Logger.error.log(
        "$error",
        stackTrace: stackTrace,
      );
    }
  }

  /// Disposes resources managed by the controller.
  ///
  /// Specifically, disposes the [nProgress] notifier to prevent memory leaks.
  void dispose() {
    Logger.information.log("Disposing the Launcher controller resources...");

    nProgress.dispose();
  }

  /// Opens the MIDlet Store releases page in the web browser.
  ///
  /// This redirects the user to the GitHub releases page for the MIDlet Store project.
  Future<void> goToReleases() async => await sActivity.openMidletStoreReleases();

  /// Attempts to restore a cached user session by performing a silent Google Sign-In.
  ///
  /// If a valid session is found, the user is automatically logged into Supabase and [ProgressEnumeration.finished] is returned.
  /// If no session is found, [ProgressEnumeration.loginRequest] is returned.
  /// In case of an error, [ProgressEnumeration.error] is returned.
  ///
  /// This method does not directly update [nProgress].
  Future<ProgressEnumeration> _findCachedSession() async {
    try {
      final GoogleSignInAuthentication? googleSignInAuthentication = await sGoogleOAuth.signInSilently();
      
      if (googleSignInAuthentication != null) {
        await sSupabase.loginWithGoogle(
          idToken: googleSignInAuthentication.idToken!,
          accessToken: googleSignInAuthentication.accessToken,
        );

        return ProgressEnumeration.finished;
      } 
      else {
        Logger.warning.log("There's no user login cached, asking for login...");

        return ProgressEnumeration.loginRequest;
      }
    } 
    catch (error, stackTrace) {
      Logger.error.log(
        "$error",
        stackTrace: stackTrace,
      );

      return ProgressEnumeration.error;
    }
  }

  /// Performs a manual Google Sign-In process and logs the user into Supabase.
  ///
  /// If the sign-in is successful, [nProgress] is updated to [ProgressEnumeration.finished].
  /// If the user cancels or an error occurs, [nProgress] is updated accordingly.
  Future<void> googleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAuthentication? authentication = await sGoogleOAuth.signIn();

      if (authentication == null) return;
      
      await sSupabase.loginWithGoogle(
        idToken: authentication.idToken!,
        accessToken: authentication.accessToken,
      );

      nProgress.value = ProgressEnumeration.finished;
    } 
    catch (error, stackTrace) {
      nProgress.value = ProgressEnumeration.error;

      Logger.error.log(
        "$error",
        stackTrace: stackTrace,
      );
    }
  }
}