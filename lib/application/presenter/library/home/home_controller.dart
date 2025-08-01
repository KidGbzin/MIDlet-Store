part of '../home/home_handler.dart';

class _Controller implements IController {

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

  @override
  Future<void> initialize() async {}

  @override
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

  Future<({int games, int midlets, int reviews, int downloads})> getGlobalStats() async {
    try {
      ({int games, int midlets}) rGamesAndMIDlets = await rSembast.boxGames.countGamesAndMIDlets();
      ({int totalDownloads, int totalReviews}) rDownloadsAndReviews = await rSupabase.getTotalDownloadsAndReviews();

      return (
        games: rGamesAndMIDlets.games,
        midlets: rGamesAndMIDlets.midlets,
        reviews: rDownloadsAndReviews.totalReviews,
        downloads: rDownloadsAndReviews.totalDownloads,
      );
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      return (
        games: 0,
        midlets: 0,
        reviews: 0,
        downloads: 0,
      );
    }
  }

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Cache ⮟

  Future<List<(Game, GameMetadata)>> getLatestGames() async {
    try {
      final List<Game> games = await rSembast.boxGames.latest();
      final List<GameMetadata> metadatas = <GameMetadata> [];

      for (final Game game in games) {
        final GameMetadata metadata = await rSembast.boxCachedRequests.getMetadata(game.identifier) ?? await rSupabase.getGameMetadataForGame(game);

        metadatas.add(metadata);

        await rSembast.boxCachedRequests.putMetadata(metadata);
      }

      return List.generate(
        games.length, (int index) {
          return (
            games[index],
            metadatas[index],
          );
        },
      );
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      return <(Game, GameMetadata)> [];
    }
  }

  Future<List<(Game, GameMetadata)>> getTop10RatedGames() async {
    try {
      final List<Game> games = <Game> [];
      final List<GameMetadata> response = await rSupabase.getTop10RatedGames();

      for (final GameMetadata metadata in response) {
        await rSembast.boxCachedRequests.putMetadata(metadata);

        games.add(await rSembast.boxGames.byKey(metadata.identifier));
      }

      return List.generate(
        games.length, (int index) {
          return (
            games[index],
            response[index],
          );
        },
      );
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<List<(Game, GameMetadata)>> getTop10MostDifficultGames() async {
    try {
      final List<Game> games = <Game> [];
      final List<GameMetadata> response = await rSupabase.getTop10MostDifficultGames();

      for (final GameMetadata metadata in response) {
        await rSembast.boxCachedRequests.putMetadata(metadata);

        games.add(await rSembast.boxGames.byKey(metadata.identifier));
      }

      return List.generate(
        games.length, (int index) {
          return (
            games[index],
            response[index],
          );
        },
      );
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<List<Game>> getTop10LongestGames() async {
    try {
      final List<Game> games = <Game> [];
      final List<GameMetadata> response = await rSupabase.getTop10LongestGames();

      for (final GameMetadata metadata in response) {
        await rSembast.boxCachedRequests.putMetadata(metadata);

        games.add(await rSembast.boxGames.byKey(metadata.identifier));
      }

      return games;
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      rethrow;
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
  Future<num> fetchAverageRating(Game game) async {
    try {
      GameMetadata? metadata = await rSembast.boxCachedRequests.getMetadata(game.identifier);

      if (metadata == null) {
        metadata = await rSupabase.getGameMetadataForGame(game);
        
        await rSembast.boxCachedRequests.putMetadata(metadata);
      }
      
      return metadata.averageRating;
    }
    catch (error, stackTrace) {
      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );

      return 0.0;
    }
  }
}