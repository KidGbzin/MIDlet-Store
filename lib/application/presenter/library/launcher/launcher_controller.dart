part of '../launcher/launcher_handler.dart';

class _Controller {

  /// Manages local storage operations, including games, favorites, recent games, and cached requests.
  final HiveRepository rHive;

  /// Manages AdMob advertising operations, includingloading, displaying, and disposing of banner and interstitial advertisements.
  final AdMobService sAdMob;

  /// Manages Firebase Cloud Messaging operations, including notification handling and token management.
  final FirebaseMessagingService sFirebaseMessaging;

  /// Handles interactions with the GitHub API, such as fetching remote files and checking for application updates.
  final GitHubService sGitHub;

  /// Manages Supabase authentication and database services, handling user sessions and data synchronization.
  final SupabaseService sSupabase;
  
  _Controller({
    required this.rHive, 
    required this.sAdMob,
    required this.sFirebaseMessaging,
    required this.sGitHub,
    required this.sSupabase,
  });

  late final ValueNotifier<ProgressEnumeration> nProgress;

  /// Initializes the handler’s core services and state notifiers.
  ///
  /// This method must be called from the `initState` of the handler widget.
  /// It prepares essential services and, if necessary, manages the initial navigation flow based on the current application state.
  Future<void> initialize(BuildContext context) async {
    nProgress = ValueNotifier<ProgressEnumeration>(ProgressEnumeration.isLoading);

    try {
      await sAdMob.initialize();
      await rHive.initialize();
      await sSupabase.initialize();

      if (context.mounted) await sFirebaseMessaging.initialize(context);

      if (await sGitHub.isVersionOutdated() && context.mounted) {
        context.gtUpdate();

        return;
      }

      if (context.mounted) {
        context.gtLogin();

        return;
      }
    } 
    catch (error, stackTrace) {
      nProgress.value = ProgressEnumeration.hasError;

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
}