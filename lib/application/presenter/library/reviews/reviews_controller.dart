part of '../reviews/reviews_handler.dart';

class _Controller {

  // MARK: Constructor ⮟

  /// Controls and triggers confetti animations for visual feedback or celebration effects.
  final ConfettiController cConfetti;

  /// The game currently being processed, displayed, or interacted with.
  final Game game;

  /// Manages local storage operations, including games, favorites, recent games, and cached requests.
  final HiveRepository rHive;

  /// Handles main database interactions, including fetching and updating game data, ratings, and related metadata.
  final SupabaseRepository rSupabase;

  /// Manages AdMob advertising operations, including loading, displaying, and disposing of banner and interstitial advertisementss.
  final AdMobService sAdMob;
  
  _Controller({
    required this.cConfetti,
    required this.game,
    required this.rHive,
    required this.rSupabase,
    required this.sAdMob,
  });

  /// Initializes the handler’s core services and state notifiers.
  ///
  /// This method must be called from the `initState` of the handler widget.
  /// It prepares essential services and, if necessary, manages the initial navigation flow based on the current application state.
  Future<void> initialize() async {
    try {
      sAdMob.clear(Views.reviews);

      nState = ValueNotifier<Progresses>(Progresses.isLoading);
      nReviews = ValueNotifier<List<Review>>(List.empty());

      nReviews.value = await rSupabase.getReviewsForGame(game);
      nState.value = Progresses.isReady;
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      nState.value = Progresses.hasError;
    }
  }

  /// Disposes the handler’s resources and notifiers.
  ///
  /// This method must be called from the `dispose` method of the handler widget to ensure proper cleanup and prevent memory leaks.
  void dispose() {
    nState.dispose();
    nReviews.dispose();

    sAdMob.clear(Views.reviews);
  }

  // MARK: Notifiers ⮟

  /// Notifies listeners about changes in the current progress state of the handler.
  late final ValueNotifier<Progresses> nState;
  
  /// Holds and notifies listeners about the current list of user reviews.
  late final ValueNotifier<List<Review>> nReviews;

  // MARK: Advertisements ⮟

  BannerAd? getAdvertisementByIndex(int index) => sAdMob.getAdvertisementByIndex(index, Views.reviews);

  void preloadNearbyAdvertisements(int index) => sAdMob.preloadNearbyAdvertisements(
    iCurrent: index,
    size: AdSize.mediumRectangle,
    view: Views.reviews,
  );

  // MARK: Vote ⮟

  /// Fetches the score (e.g., upvotes and downvotes) for a given review.
  Future<(int, int)> getReviewScore(Review review) async => rSupabase.getScoreForReview(review);

  /// Submits or updates a vote for a given review.
  Future<(int, int)> submitVote(Review review, int vote) async => rSupabase.upsertVoteForReview(review, vote);

  // MARK: User Review ⮟

  /// Retrieves the user's review for the current game from cache or remote source.
  ///
  /// If the cached review is missing, fetches it from the remote service and caches it.
  /// On error, logs the issue and returns a default empty review.
  Future<Review> getUserReview() async {
    final GameMetadata metadata = rHive.boxCachedRequests.get('${game.identifier}') ?? GameMetadata(
      identifier: game.identifier,
    );

    try {
      metadata.myReview ??= await rSupabase.getUserReviewForGame(game);
    }
    catch (error, stackTrace) {
      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );

      metadata.myReview = Review.noReview();
    }

    rHive.boxCachedRequests.put(metadata);

    return metadata.myReview!;
  }

  /// Inserts or updates the user's rating for a game.
  ///
  /// After submitting a rating, it updates all relevant variables, including the user's rating, the game's average rating, and the count of ratings by stars.
  Future<void> submitRating(BuildContext context, int rating, String body) async {
    final GameMetadata metadata = rHive.boxCachedRequests.get('${game.identifier}') ?? GameMetadata(
      identifier: game.identifier,
    );

    try {
      final Review review = await rSupabase.upsertReviewForGame(game, rating, body);

      metadata.myReview = review;
    }
    catch (error, stackTrace) {
      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );

      return;
    }

    try {
      metadata.totalRatings = await rSupabase.countReviewsForGame(game);
    }
    catch (error, stackTrace) {
      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );

      metadata.totalRatings = 0;
    }

    try {
      metadata.averageRating = await rSupabase.getAverageRatingForGame(game);
    }
    catch (error, stackTrace) {
      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );

      metadata.averageRating = 0.0;
    }

    try {
      metadata.stars = await rSupabase.countRatingsByStarForGame(game);
    }
    catch (error, stackTrace) {
      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );

      metadata.stars = <String, int> {
        "5": 0,
        "4": 0,
        "3": 0,
        "2": 0,
        "1": 0,
      };
    }
  
    rHive.boxCachedRequests.put(metadata);
    updateLocalReview(metadata.myReview!);

    if (context.mounted) context.pop();

    cConfetti.play();
  }

  /// Updates an existing review by identifier or inserts it at the start if not found.
  void updateLocalReview(Review review) {
    final List<Review> temporary = nReviews.value;
    final int index = temporary.indexWhere((r) => r.identifier == review.identifier);

    if (index != -1) {
      temporary[index] = review;
    }
    else {
      temporary.insert(0, review);
    }
    nReviews.value = List<Review>.from(temporary);
  }
}