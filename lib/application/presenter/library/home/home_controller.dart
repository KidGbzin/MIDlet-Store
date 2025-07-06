part of '../home/home_handler.dart';

class _Controller {

  /// Manages cloud storage operations, including downloading and caching assets such as game previews and thumbnails.
  final BucketRepository rBucket;

  /// Manages local storage operations, including games, favorites, recent games, and cached requests.
  final SembastRepository rSembast;

  /// Handles main database interactions, including fetching and updating game data, ratings, and related metadata.
  final SupabaseRepository rSupabase;

  _Controller({
    required this.rBucket,
    required this.rSembast,
    required this.rSupabase,
  });

  void dispose() {}

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Storage ⮟

  /// Retrieves a [Future] that resolves to a thumbnail [File] for a given game title.
  ///
  /// This method fetches the cover image file from the bucket storage using the provided [title].
  Future<File?> fetchThumbnail(Game game) {
    try {
      return rBucket.cover(game.title);
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      return Future.value(null);
    }
  }

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Cache ⮟

  Future<List<Game>> getLatestGames() async {
    try {
      return await rSembast.boxGames.latest();
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      return <Game> [];
    }
  }

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Database ⮟

  /// Retrieves the current average rating of the specified game.
  /// 
  /// This method first attempts to fetch the average rating from the cache using the game's identifier. 
  /// If the value is not cached, it queries the database to retrieve the rating, handling any errors that might occur during the process by setting a default value of 0.0.
  /// The fetched or defaulted value is then stored in the cache for future use.
  Future<double> fetchAverageRating(Game game) async {
    final GameMetadata metadata = await rSembast.boxCachedRequests.get(game.identifier) ?? GameMetadata(
      identifier: game.identifier,
    );
    try {
      metadata.averageRating ??= await rSupabase.getAverageRatingForGame(game);
    }
    catch (error, stackTrace) {
      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );

      metadata.averageRating = 0.0;
    }

    await rSembast.boxCachedRequests.put(metadata);

    return metadata.averageRating!;
  }
}