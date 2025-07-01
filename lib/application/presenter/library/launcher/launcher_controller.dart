part of '../launcher/launcher_handler.dart';

class _Controller {

  // MARK: Constructor ⮟

  /// Manages local storage operations, including games, favorites, recent games, and cached requests.
  final SembastRepository rSembast;

  /// Manages AdMob advertising operations, including loading, displaying, and disposing of banner and interstitial advertisements.
  final AdMobService sAdMob;

  /// Manages Firebase Cloud Messaging operations, including notification handling and token management.
  final FirebaseMessagingService sFirebaseMessaging;

  /// Handles interactions with the GitHub API, such as fetching remote files and checking for application updates.
  final GitHubService sGitHub;

  /// Manages Supabase authentication and database services, handling user sessions and data synchronization.
  final SupabaseService sSupabase;
  
  _Controller({
    required this.rSembast,
    required this.sAdMob,
    required this.sFirebaseMessaging,
    required this.sGitHub,
    required this.sSupabase,
  });

  /// Initializes the handler’s core services and state notifiers.
  ///
  /// This method must be called from the `initState` of the handler widget.
  /// It prepares essential services and, if necessary, manages the initial navigation flow based on the current application state.
  Future<void> initialize(BuildContext context) async {
    try {
      nProgress = ValueNotifier<Progresses>(Progresses.isLoading);
      nError = ValueNotifier<Object?>(null);

      await sAdMob.initialize();
      await sSupabase.initialize();
      await rSembast.initialize();

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
      nProgress.value = Progresses.hasError;
      nError.value = error;

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

  // MARK: Notifiers ⮟

  /// Notifies listeners about changes in the current progress state of the handler.
  late final ValueNotifier<Progresses> nProgress;

  late final ValueNotifier<Object?> nError;
}