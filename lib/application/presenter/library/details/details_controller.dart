part of '../details/details_handler.dart';

class _Controller {

  // MARK: Constructor ⮟

  /// Controls and triggers confetti animations for visual feedback or celebration effects.
  final ConfettiController cConfetti;

  /// The game currently being processed, displayed, or interacted with.
  final Game game;

  /// Manages cloud storage operations, including downloading and caching assets such as game previews and thumbnails.
  final BucketRepository rBucket;

  /// Handles backend operations using Supabase, including user authentication, data syncing, and remote queries.
  final SupabaseRepository rSupabase;

  /// Manages local storage operations, including games, favorites, recent games, and cached requests.
  final SembastRepository rSembast;

  /// Provides access to native Android activity functions, such as opening URLs or interacting with platform features.
  final ActivityService sActivity;

  /// Manages AdMob advertising operations, including loading, displaying, and disposing of banner and interstitial advertisementss.
  final AdMobService sAdMob;

  _Controller({
    required this.cConfetti,
    required this.game,
    required this.rBucket,
    required this.rSembast,
    required this.rSupabase,
    required this.sActivity,
    required this.sAdMob,
  });

  late final Map<String, BannerAd?> _advertisements;

  /// Initializes the handler’s core services and state notifiers.
  ///
  /// This method must be called from the `initState` of the handler widget.
  /// It prepares essential services and, if necessary, manages the initial navigation flow based on the current application state.
  Future<void> initialize() async {
    try {
      nProgress = ValueNotifier(Progresses.isLoading);
      nThumbnail = ValueNotifier<File?>(null);
      
      fetchThumbnail();

      _advertisements = await sAdMob.getMultipleAdvertisements(["0", "1", "2", "3"], AdSize.banner);

      nProgress.value = Progresses.isFinished;
      
      playAudio();
      _fetchGameMetadata();
      await rSembast.boxRecentGames.put(game.identifier, game.fTitle);
    }
    catch (error, stackTrace) {
      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );
    }
  }

  /// Disposes the handler’s resources and notifiers.
  ///
  /// This method must be called from the `dispose` method of the handler widget to ensure proper cleanup and prevent memory leaks.
  void dispose() {
    cConfetti.dispose();
    
    nGameMetadata.dispose();
    nThumbnail.dispose();

    for (final BannerAd? advertisement in _advertisements.values) {
      if (advertisement != null) advertisement.dispose();
    }
    _advertisements.clear();
    
    _player.dispose();
  }

  Future<({double average, (int, int, int, int, int) ratings, int total})> fetchRatingDistribution() async {
    final (int s1, int s2, int s3, int s4, int s5) = await rSupabase.getRatingDistributionForGame(game);
    final int total = s1 + s2 + s3 + s4 + s5;
    final double average = total == 0 ? 0 : (1 * s1 + 2 * s2 + 3 * s3 + 4 * s4 + 5 * s5) / total;

    return (
      average: average,
      ratings: (s1, s2, s3, s4, s5),
      total: total,
    );
  }

  // MARK: Notifiers ⮟

  late final ValueNotifier<Progresses> nProgress;
  late final ValueNotifier<GameMetadata> nGameMetadata = ValueNotifier(GameMetadata.empty(game.identifier));
  late final ValueNotifier<File?> nThumbnail;

  // MARK: Reviews ⮟

  Future<List<Review>> getTop3Reviews() async => rSupabase.getTop3ReviewsForGame(game);

  BannerAd? getAdvertisement(String key) => _advertisements[key];

  /// Fetch all the game data needed and updates its listeners.
  /// 
  /// This function retrieves various types of game data from the database, such as average ratings, user ratings, total ratings, and ratings by star count.
  /// It updates the corresponding reactive variables and caches the data for future use.
  /// 
  /// This function is initialized within the `initialize` function.
  Future<void> _fetchGameMetadata() async {
    try {
      GameMetadata? metadata = await rSembast.boxCachedRequests.getMetadata(game.identifier);

      if (metadata == null) {
        metadata = await rSupabase.getGameMetadataForGame(game);
        
        await rSembast.boxCachedRequests.putMetadata(metadata);
      }

      nGameMetadata.value = metadata;
    }
    catch (error, stackTrace) {
      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );

      nGameMetadata.value = GameMetadata.empty(game.identifier);
    }
  }

  /// Inserts or updates the user's rating for a game.
  ///
  /// After submitting a rating, it updates all relevant variables, including the user's rating, the game's average rating, and the count of ratings by stars.
  Future<void> submitRating(int rating, String body) async {
    try {
      final Review review = await rSupabase.upsertReviewForGame(game, rating, body);

      try {
        final GameMetadata metadata = await rSupabase.getGameMetadataForGame(game);
        
        await rSembast.boxCachedRequests.putOwnReview(game.identifier, review);
        await rSembast.boxCachedRequests.putMetadata(metadata);

        nGameMetadata.value = metadata;
      }
      catch (error, stackTrace) {
        Logger.error(
          '$error',
          stackTrace: stackTrace,
        );
      }

      cConfetti.play();
    }
    catch (error, stackTrace) {
      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );
    }

    // TODO: Colcoar estados de erro e sucesso.
  }

  /// Retrieves a [Future] that resolves to a thumbnail [File] for a given game title.
  ///
  /// This method fetches the cover image file from the bucket storage using the provided [title].
  Future<File?> fetchThumbnailT(Game game) { // TODO: Tem 3 fetch thumb aqui prcciso diff
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

  /// The audio player used to manage and play the game's theme audio.
  ///
  /// This instance leverages the [`audioplayers`](https://pub.dev/packages/audioplayers) package to handle audio functionalities like play, pause, and stop.
  /// It provides a convenient way to control the playback of the game's theme music, such as playing, pausing, and stopping.
  final AudioPlayer _player = AudioPlayer();

  /// Plays the game's theme audio.
  /// 
  /// Attempts to load the audio from the bucket and play it.
  /// If the audio cannot be loaded for any reason, it does nothing.
  Future<void> playAudio() async {
    try {
      final File file = await _audio;
      await _player.setSource(DeviceFileSource(file.path));
      await _player.resume();
    }
    catch (_) {}
  }

  /// Resumes the game's theme audio if it was paused.
  /// 
  /// Does nothing if the audio is not paused.
  void resumeAudio() => _player.resume();

  /// Stops the game's theme audio if it is playing.
  /// 
  /// Does nothing if the audio is not playing.
  void pauseAudio() => _player.stop();


  /// Retrieves a [Future] that resolves to a [File] containing the audio file associated with the current game.
  ///
  /// This getter fetches the audio file associated with the current game from the storage bucket.
  /// The audio file is returned as a [File] object, which can be used to play the audio.
  Future<File> get _audio => rBucket.audio(game.title);

  Future<File> get logo => rBucket.publisher(game.publisher);

  /// Retrieves a [Future] that resolves to a [List] of [Uint8List] objects representing preview images from the bucket.
  ///
  /// This getter fetches a list of preview images associated with the current game from the storage bucket.
  /// The images are returned as a list of [Uint8List] objects, which can be used to display the previews in the UI.
  /// 
  /// The [Uint8List] objects contain the image data in the PNG format.
  Future<List<Uint8List>> get previews => rBucket.previews(game.title);

  /// Retrieves a [Future] that resolves to a [File] representing the thumbnail image from the bucket.
  ///
  /// This getter fetches the thumbnail image associated with the current game from the storage bucket.
  /// The image is returned as a [File] object, which can be used to display the thumbnail in the UI.
  Future<File> thumbnail(String title) => rBucket.cover(title);

  /// Fetches the thumbnail image associated with the current game from the bucket and updates the state of the thumbnail.
  ///
  /// This method fetches the thumbnail image associated with the current game from the storage bucket.
  /// The image is stored as a [File] object, which is used to update the state of the [nThumbnail].
  /// If the thumbnail image is not available, the [nThumbnail] is set to [null].
  /// 
  /// The [_Cover] component listens to the [nThumbnail] to update the UI accordingly.
  Future<void> fetchThumbnail() async => nThumbnail.value = await rBucket.cover(game.title);

  /// A lazily initialized list of recommended games from the same publisher.
  ///
  /// This list is used to store games recommended based on the publisher of the current game.
  late List<Game> _topPublisherGames = <Game> [];

  /// A lazily initialized list of top related games.
  /// 
  /// This list stores games that are considered to be related to the current game based on shared tags or other relevant criteria.
  late List<Game> _topRelatedGames = <Game> [];

  /// Fetches a list of recommended games from the same publisher as the current game.
  /// 
  /// The function retrieves up to 8 games published by the same publisher, shuffling them for randomization.
  /// It collects their game objects, ratings, and thumbnail images to return in a structured format.
  Future<({List<Game> games, List<double> ratings, List<File> thumbnails})> getTopPublisherGames() async {
    return (
      games: <Game> [],
      ratings: <double> [],
      thumbnails: <File> [],
    );

    // TODO: Simplificar isso aqui que esta muito complicado.
    // final List<double> ratings = <double> [];
    // final List<File> thumbnails = <File> []; 

    // if (_topPublisherGames.isEmpty) {
    //   _topPublisherGames = await rSembast.boxGames.byPublisher(game.publisher);
    //   _topPublisherGames.shuffle();
    //   _topPublisherGames = _topPublisherGames.take(8).toList();
    // }

    // for (Game element in _topPublisherGames) {
    //   ratings.add(await _getAverageRating(element));
    //   thumbnails.add(await rBucket.cover(element.title).catchError((_) => File('/')));
    // }

    // ({List<Game> games, List<double> ratings, List<File> thumbnails}) record = (
    //   games: _topPublisherGames,
    //   ratings: ratings,
    //   thumbnails: thumbnails,
    // );

    // return record;
  }

  Future<List<Game>> get10PublisherGames() async => await rSembast.boxGames.byPublisher(game.publisher);

  Future<List<Game>> getTop10RelatedGames() async => await rSembast.boxGames.related(game);
}