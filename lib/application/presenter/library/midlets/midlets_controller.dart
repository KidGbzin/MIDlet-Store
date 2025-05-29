part of '../midlets/midlets_handler.dart';

class _Controller {

  // MARK: Constructor ⮟

  /// The game currently being processed, displayed, or interacted with.
  final Game game;

  final BucketRepository rBucket;

  /// Manages AdMob advertising operations, including loading, displaying, and disposing of banner and interstitial advertisementss.
  final AdMobService sAdMob;

  _Controller({
    required this.game,
    required this.rBucket,
    required this.sAdMob,
  });

  /// Initializes the handler’s core services and state notifiers.
  ///
  /// This method must be called from the `initState` of the handler widget.
  /// It prepares essential services and, if necessary, manages the initial navigation flow based on the current application state.
  Future<void> initialize() async {
    nMIDletsLength = ValueNotifier<int>(game.midlets.length);
    nThumbnail = ValueNotifier<File?>(null);

    try {
      nThumbnail.value = await _thumbnail;
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );
    }
  }

  /// Disposes the handler’s resources and notifiers.
  ///
  /// This method must be called from the `dispose` method of the handler widget to ensure proper cleanup and prevent memory leaks.
  void dispose() {
    nMIDletsLength.dispose();
    nThumbnail.dispose();
  }

  // MARK: Notifiers ⮟

  late final ValueNotifier<int> nMIDletsLength;

  late final ValueNotifier<File?> nThumbnail;

  // MARK: Thumbnail ⮟

  Future<File?> get _thumbnail async => await rBucket.cover(game.title);
}