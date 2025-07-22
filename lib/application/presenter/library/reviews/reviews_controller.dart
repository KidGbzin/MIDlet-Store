part of '../reviews/reviews_handler.dart';

class _Controller implements IController {

  /// Controls and triggers confetti animations for visual feedback or celebration effects.
  final ConfettiController cConfetti;

  /// The game currently being processed, displayed, or interacted with.
  final Game game;

  /// Manages local storage operations, including games, favorites, recent games, and cached requests.
  final SembastRepository rSembast;

  /// Handles main database interactions, including fetching and updating game data, ratings, and related metadata.
  final SupabaseRepository rSupabase;

  /// Manages AdMob advertising operations, including loading, displaying, and disposing of banner and interstitial advertisementss.
  final AdMobService sAdMob;
  
  _Controller({
    required this.cConfetti,
    required this.game,
    required this.rSembast,
    required this.rSupabase,
    required this.sAdMob,
  });

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Initialization ⮟

  @override
  Future<void> initialize() async {
    try {
      sAdMob.clear(Views.reviews);

      nReviews.value = await rSupabase.getReviewsForGame(game);
      nProgress.value = (
        state: Progresses.isReady,
        error: null,
      );
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      nProgress.value = (
        state: Progresses.hasError,
        error: error,
      );
    }
  }

  @override
  void dispose() {
    nProgress.dispose();
    nReviews.dispose();

    sAdMob.clear(Views.reviews);
  }

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Notifiers ⮟

  /// Notifies listeners about changes in the current progress state of the handler.
  late final ValueNotifier<({
    Progresses state,
    Object? error,
  })> nProgress = ValueNotifier((
    state: Progresses.isLoading,
    error: null,
  ));
  
  /// Holds and notifies listeners about the current list of user reviews.
  late final ValueNotifier<List<Review>> nReviews = ValueNotifier(<Review> []);

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Advertisements ⮟

  BannerAd? getAdvertisementByIndex(int index) => sAdMob.getAdvertisementByIndex(index, Views.reviews);

  void preloadNearbyAdvertisements(int index) => sAdMob.preloadNearbyAdvertisements(
    iCurrent: index,
    size: AdSize.mediumRectangle,
    view: Views.reviews,
  );

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Votes ⮟

  /// Submits or updates a vote for a given review.
  Future<Review> submitVote(Review review, int vote) async => await rSupabase.upsertVoteForReview(review, vote);

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Reviews ⮟

  /// Retrieves the user's review for the current game from cache or remote source.
  ///
  /// If the cached review is missing, fetches it from the remote service and caches it.
  /// On error, logs the issue and returns a default empty review.
  Future<Review> getUserReview() async {
    try {
      Review? review = await rSembast.boxCachedRequests.getOwnReview(game.identifier);

      if (review == null) {
        review = await rSupabase.getUserReviewForGame(game);

        await rSembast.boxCachedRequests.putOwnReview(game.identifier, review ??= Review.empty());
      }

      return review;
    }
    catch (error, stackTrace) {
      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );

      return Review.empty();
    }
  }

  /// Submits a new review or updates an existing one for the current game.
  ///
  /// Sends the review to the remote service and updates the local cache with the updated review and refresh the current reviews list.
  Future<void> submitReview(Review review) async {
    final Review updatedReview = await rSupabase.upsertReviewForGame(game, review);

    try {
      final GameMetadata metadata = await rSupabase.getGameMetadataForGame(game);
    
      await rSembast.boxCachedRequests.putOwnReview(game.identifier, updatedReview);
      await rSembast.boxCachedRequests.putMetadata(metadata);
    }

    catch (error, stackTrace) {
      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );
    }

    try {
      _refreshReviews(updatedReview);
    }
    catch (error, stackTrace) {
      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );
    }
    
    cConfetti.play();
  }

  /// Updates an existing review in the list if it matches the given identifier.
  /// If a matching review is not found, the new review is inserted at the start of the list.
  /// 
  /// This ensures that the latest review is always at the front if it's newly added.
  void _refreshReviews(Review review) {
    final List<Review> temporary = nReviews.value;
    final int index = temporary.indexWhere((r) => r.gameKey == review.gameKey);

    if (index != -1) {
      temporary[index] = review;
    }
    else {
      temporary.insert(0, review);
    }
    nReviews.value = List<Review>.from(temporary);
  }
}