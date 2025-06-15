part of '../installation/installation_handler.dart';

class _Controller {

  // MARK: Constructor ⮟

  /// The game currently being processed, displayed, or interacted with.
  final Game game;

  /// The Java ME application (MIDlet) object.
  final MIDlet midlet;

  /// Manages cloud storage operations, including downloading and caching assets such as game previews and thumbnails.
  final BucketRepository rBucket;

  /// Manages local storage operations, including games, favorites, recent games, and cached requests.
  final HiveRepository rHive;

  /// Handles main database interactions, including fetching and updating game data, ratings, and related metadata.
  final SupabaseRepository rSupabase;

  /// Provides access to native Android activity functions, such as opening URLs or interacting with platform features.
  final ActivityService sActivity;

  /// Manages AdMob advertising operations, includingloading, displaying, and disposing of banner and interstitial advertisements.
  final AdMobService sAdMob;

  _Controller({
    required this.game,
    required this.midlet,
    required this.rBucket,
    required this.rHive,
    required this.rSupabase,
    required this.sAdMob,
    required this.sActivity,
  });

  late final Map<String, BannerAd?> _advertisements;

  /// Initializes the handler’s core services and state notifiers.
  ///
  /// This method must be called from the `initState` of the handler widget.
  /// It prepares essential services and, if necessary, manages the initial navigation flow based on the current application state.
  Future<void> initialize() async {
    try {
      nProgress = ValueNotifier<(Progresses, Object?)>((Progresses.isLoading, null));  
      nEmulator = ValueNotifier<Emulators>(Emulators.j2meLoader);

      _advertisements = await sAdMob.getMultipleAdvertisements(["0", "1", "2"], AdSize.mediumRectangle);

      nProgress.value = (Progresses.isReady, null);
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      nProgress.value = (Progresses.hasError, error);
    }
  }

  /// Disposes the handler’s resources and notifiers.
  ///
  /// This method must be called from the `dispose` method of the handler widget to ensure proper cleanup and prevent memory leaks.
  void dispose() {
    nProgress.dispose();
    nEmulator.dispose();

    for (final BannerAd? advertisement in _advertisements.values) {
      if (advertisement != null) advertisement.dispose();
    }
    _advertisements.clear();
  }

  // MARK: Notifiers ⮟

  /// Notifies listeners of the currently selected emulator.
  late final ValueNotifier<Emulators> nEmulator;

  /// Notifies listeners of the current progress state and optional error.
  late final ValueNotifier<(Progresses, Object?)> nProgress;

  // MARK: Advertisements ⮟

  /// Retrieves the [BannerAd] associated with the given [key], or null if not found.
  BannerAd? getAdvertisement(String key) => _advertisements[key];

  // MARK: Installation ⮟

  /// Downloads the MIDlet, updates metadata, and launches the emulator.
  ///
  /// Increments downloads remotely and locally, saves metadata, and opens the MIDlet in the selected emulator.
  Future<void> tryDownloadAndInstallMIDlet(BuildContext context) async {
    final GameMetadata metadata = rHive.boxCachedRequests.get('${game.identifier}') ?? GameMetadata(
      identifier: game.identifier,
    );
    final File file = await rBucket.midlet(midlet);

    await rSupabase.incrementDownloadsForGame(game);
      
    metadata.downloads ??= 0;
    metadata.downloads = metadata.downloads! + 1;
    rHive.boxCachedRequests.put(metadata);

    await sActivity.emulator(file, nEmulator.value);

    if (context.mounted) context.pop();
  }

  // MARK: URL Launchers ⮟

  Future<void> launchSourceUrl(BuildContext context) async {
    try {
      await sActivity.url(midlet.source);

      if (context.mounted) context.pop();
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );
    }
  }

  /// Opens the emulator’s GitHub or Play Store page using a URL.
  Future<void> launchEmulatorPage(BuildContext context, String link) async {
    try {
      await sActivity.url(link);

      if (context.mounted) context.pop();
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );
    }
  }
}