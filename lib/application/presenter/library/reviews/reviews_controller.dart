part of '../reviews/reviews_handler.dart';

class _Controller {

  // MARK: Constructor ⮟

  /// The game currently being processed, displayed, or interacted with.
  final Game game;

  /// Handles main database interactions, including fetching and updating game data, ratings, and related metadata.
  final SupabaseRepository rSupabase;

  /// Manages AdMob advertising operations, including loading, displaying, and disposing of banner and interstitial advertisementss.
  final AdMobService sAdMob;
  
  _Controller({
    required this.game,
    required this.rSupabase,
    required this.sAdMob,
  });

  late final List<Review> _reviews;

  /// Initializes the handler’s core services and state notifiers.
  ///
  /// This method must be called from the `initState` of the handler widget.
  /// It prepares essential services and, if necessary, manages the initial navigation flow based on the current application state.
  Future<void> initialize() async {
    try {
      nState = ValueNotifier<ProgressEnumeration>(ProgressEnumeration.isLoading);
      nReviews = ValueNotifier<List<Review>>(List.empty());

      _reviews = await rSupabase.getGameReviews(game);

      nReviews.value = _reviews;
      nState.value = ProgressEnumeration.isReady;
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      nState.value = ProgressEnumeration.hasError;
    }
  }

  /// Disposes the handler’s resources and notifiers.
  ///
  /// This method must be called from the `dispose` method of the handler widget to ensure proper cleanup and prevent memory leaks.
  void dispose() {
    nState.dispose();
    nReviews.dispose();
  }

  // MARK: Notifiers ⮟

  late final ValueNotifier<ProgressEnumeration> nState;

  late final ValueNotifier<List<Review>> nReviews;
}