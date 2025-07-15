part of '../profile/profile_handler.dart';

class _Controller implements IController {
  
  /// Manages local storage operations, including games, favorites, recent games, and cached requests.
  final SembastRepository rSembast;

  /// Handles main database interactions, including fetching and updating game data, ratings, and related metadata.
  final SupabaseRepository rSupabase;

  _Controller({
    required this.rSembast,
    required this.rSupabase,
  });

  late final ({
    String identifier,
    int downloads,
    String nickname,
  }) profile;

  @override
  void dispose() {
    nProgress.dispose();
  }

  @override
  Future<void> initialize() async {
    try {
      profile = await getProfile();
      nProgress.value = (
        error: null,
        state: Progresses.isReady,
      );
    }
    catch (error, stackTrace) {
      nProgress.value = (
        error: error,
        state: Progresses.hasError,
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
    error: null,
    state: Progresses.isLoading,
  ));

  Future<List<({Review review, String title})>> getTop5Reviews() async {
    try {
      final List<Review> reviews = await rSupabase.getReviewsByUser(
        profile.identifier,
        limit: 10,
      );
      final List<String> titles = <String> [];

      for (Review iReview in reviews) {
        final Game game = await rSembast.boxGames.byKey(iReview.gameKey);

        titles.add(game.fTitle);
      }

      return List.generate(
        reviews.length,
        (int index) {
          return (
            review: reviews[index],
            title: titles[index],
          );
        },
      );
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      return [];
    }
  }

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Votes ⮟

  /// Submits or updates a vote for a given review.
  Future<Review> submitVote(Review review, int vote) async {
    return await rSupabase.upsertVoteForReview(review, vote);
  }

  Future<({
    int downloads,
    String identifier,
    String nickname,
  })> getProfile() async {
    return rSupabase.getProfileForUser(null);
  }


}