part of '../details/details_handler.dart';

// CONTROLLER 🧩: =============================================================================================================================================================== //

/// The controller responsible for handling the [Details] state and managing the associated data.
///
/// This controller is responsible for fetching, updating, and disposing of data related to a specific game.
class _Controller {

  _Controller({
    required this.activity,
    required this.bucket,
    required this.database,
    required this.game,
    required this.hive,
  });

  final ActivityService activity;

  /// A repository for managing data retrieval and storage within the bucket.
  ///
  /// Responsible for handling interactions with external storage systems, including retrieving and caching assets such as game previews and thumbnails.
  final BucketRepository bucket;

  /// The service responsible for interacting with the database for data operations.
  ///
  /// This [SupabaseRepository] instance provides methods for reading, writing, and querying data from the database. 
  final SupabaseRepository database;

  /// The service used for data operations with the local database.
  /// 
  /// This [HiveRepository] instance handles interactions with the local storage (Hive), providing methods for reading, writing, and querying game data or related information.
  final HiveRepository hive;

  /// The game whose data is to be displayed or manipulated.
  /// 
  /// This [Game] instance holds all relevant information about the current game, such as title, description, ratings, and associated assets like previews and thumbnails.
  final Game game;
 
  /// Initializes the details controller by setting up favorite status and updating recent games.
  ///
  /// This function is responsible for initializing key state values related to a game.
  /// It checks if the current game is marked as a favorite and updates the recent games list.
  /// If an error occurs during initialization, it logs the error and its stack trace.
  Future<void> initialize() async {
    try {
      fetchThumbnail();
      _updateGameData();
      isFavoriteState = ValueNotifier(hive.favorites.contains(game));
      hive.recentGames.put(game);
    }
    catch (error, stackTrace) {
      Logger.error.print(
        label: 'Details Controller • Initialize',
        message: '$error',
        stackTrace: stackTrace,
      );
    }
  }

  /// Discards the resources used by the controller and cleans up allocated memory.
  ///
  /// This method should be called when the controller is no longer needed to free up resources and prevent memory leaks.
  /// It disposes of all [ValueNotifier] instances that the controller is using.
  void dispose() {
    isFavoriteState.dispose();

    averageRating.dispose();
    totalRatings.dispose();
    starsCount.dispose();
    myRating.dispose();
  }

  // BUCKET 🧩: ================================================================================================================================================================= //

  /// Retrieves a [Future] that resolves to a [List] of [Uint8List] objects representing preview images from the bucket.
  ///
  /// This getter fetches a list of preview images associated with the current game from the storage bucket. 
  /// The images are returned as a list of [Uint8List] objects, which can be used to display the previews in the UI.
  Future<List<Uint8List>> get previews => bucket.previews(game.title);

  /// Retrieves a [Future] that resolves to a [File] representing the thumbnail image from the bucket.
  ///
  /// This getter fetches the thumbnail image associated with the current game from the storage bucket.
  /// The image is returned as a [File] object, which can be used to display the thumbnail in the UI.
  Future<File> thumbnail(String title) => bucket.cover(title);

  ValueNotifier<File?> thumbnailState = ValueNotifier<File?>(null);

  Future<void> fetchThumbnail() async {
    thumbnailState.value = await bucket.cover(game.title);
  }

  // FAVORITES 🧩: ============================================================================================================================================================== //

  /// A [ValueNotifier] that tracks the favorite state of the game.
  ///
  /// This notifier is used in the [_BookmarkButton] component to indicate whether the game has been marked as a favorite.
  late final ValueNotifier<bool> isFavoriteState;

  /// Toggles the bookmark status of the current game.
  ///
  /// This function switches the game's status between favorite and non-favorite. 
  /// If the game is currently marked as a favorite, it will be removed from the favorites cache. 
  /// If it is not marked as a favorite, it will be added to the favorites cache.
  void toggleBookmarkStatus() {
    if (isFavoriteState.value) {
      hive.favorites.remove(game);
    }
    else {
      hive.favorites.put(game);
    }
    isFavoriteState.value = !isFavoriteState.value;
  }

  // RECOMENDATIONS 🧩: ========================================================================================================================================================= //

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
    final List<double> ratings = <double> [];
    final List<File> thumbnails = <File> []; 

    if (_topPublisherGames.isEmpty) {
      _topPublisherGames = hive.games.fromPublisher(game.publisher);
      _topPublisherGames.shuffle();
      _topPublisherGames = _topPublisherGames.take(8).toList();
    }

    for (Game element in _topPublisherGames) {
      ratings.add(await getAverageRating(element));
      thumbnails.add(await bucket.cover(element.title).catchError((_) => File('/')));
    }

    ({List<Game> games, List<double> ratings, List<File> thumbnails}) record = (
      games: _topPublisherGames,
      ratings: ratings,
      thumbnails: thumbnails,
    );

    return record;
  }

  /// Retrieves the top related games along with their ratings and thumbnails.
  ///
  /// This function checks if the list of top related games is empty.
  /// If it is, it fetches the related games using a call to `topRelatedGames`.
  /// Then, for each game, it retrieves its rating and thumbnail image if available, and returns the results as a tuple containing the related games, their ratings, and thumbnails.
  Future<({List<Game> games, List<double> ratings, List<File> thumbnails})> getTopRelatedGames() async {
    final List<double> ratings = <double> [];
    final List<File> thumbnails = <File> []; 

    if (_topRelatedGames.isEmpty) {
      _topRelatedGames = await hive.games.topRelatedGames(game);
    }

    for (Game element in _topRelatedGames) {
      ratings.add(await getAverageRating(element));
      thumbnails.add(await bucket.cover(element.title).catchError((_) => File('/')));
    }

    ({List<Game> games, List<double> ratings, List<File> thumbnails}) record = (
      games: _topRelatedGames,
      ratings: ratings,
      thumbnails: thumbnails,
    );

    return record;
  }

  // GAME 🧩: =================================================================================================================================================================== //

  /// Tracks the current average rating of the game.
  ///
  /// This [ValueNotifier] holds the average rating of the game as a [double]. 
  /// It is initialized to `0` by default, indicating that no ratings have been submitted yet.
  final ValueNotifier<double> averageRating = ValueNotifier(0);

  /// Tracks the user's rating for the current game.
  ///
  /// This [ValueNotifier] holds the user's rating as an integer. 
  /// If no rating has been provided by the user, the default value is `0`.
  final ValueNotifier<int> myRating = ValueNotifier(0);

  /// Tracks the total number of ratings for the current game.
  ///
  /// This [ValueNotifier] holds the total count of user ratings submitted for the game. 
  /// It is initialized to `0` by default, representing no ratings.
  final ValueNotifier<int> totalRatings = ValueNotifier(0);

  /// A [ValueNotifier] containing a [Map] that tracks the count of ratings for each star level.
  ///
  /// The [Map] keys represent the star levels (from 1 to 5).
  /// The values represent the count of ratings for each corresponding star.
  /// All counts are initialized to `0` by default.
  final ValueNotifier<Map<String, int>> starsCount = ValueNotifier(<String, int> {
    "5": 0,
    "4": 0,
    "3": 0,
    "2": 0,
    "1": 0,
  });

  /// Fetch all the game data needed and updates its listeners.
  /// 
  /// This function retrieves various types of game data from the database, such as average ratings, user ratings, total ratings, and ratings by star count.
  /// It updates the corresponding reactive variables and caches the data for future use.
  /// 
  /// This function is initialized within the `initialize` function.
  Future<void> _updateGameData() async {
    final GameData data = hive.cachedRequests.get('${game.identifier}') ?? GameData(
      identifier: game.identifier,
    );

    // Fetch and update average rating.
    try {
      data.averageRating ??= await database.getAverageRatingByGame(game);
      averageRating.value = data.averageRating!;
    }
    catch (error, stackTrace) {
      Logger.error.print(
        message: '$error',
        label: 'Details Controller | Average Rating',
        stackTrace: stackTrace,
      );
      data.averageRating = 0.0;
    }

    // Fetch and update user rating.
    try {
      data.myRating ??= await database.getUserRatingForGame(game);
      myRating.value = data.myRating!;
    }
    catch (error, stackTrace) {
      Logger.error.print(
        message: '$error',
        label: 'Details Controller | User Rating',
        stackTrace: stackTrace,
      );
      data.myRating = 0;
    }

    // Fetch and update total ratings count.
    try {
      data.totalRatings ??= await database.getGameRatingsCount(game);
      totalRatings.value = data.totalRatings!;
    }
    catch (error, stackTrace) {
      Logger.error.print(
        message: '$error',
        label: 'Details Controller | Total Ratings',
        stackTrace: stackTrace,
      );
      data.totalRatings = 0;
    }

    // Fetch and update individual star count.
    try {
      data.stars ??= await database.getGameRatingsByStarsCount(game);
      starsCount.value = data.stars!;
    }
    catch (error, stackTrace) {
      Logger.error.print(
        message: '$error',
        label: 'Details Controller | Ratings by Star',
        stackTrace: stackTrace,
      );
      data.stars = <String, int> {
        "5": 0,
        "4": 0,
        "3": 0,
        "2": 0,
        "1": 0,
      };
    }
  
    hive.cachedRequests.put(data);
  }

  /// Inserts or updates the user's rating for a game.
  ///
  /// This function is primarily used in the [_SubmitRatingModal] to allow users to rate a game.
  /// After submitting a rating, it updates all relevant variables, including the user's rating, the game's average rating, and the count of ratings by stars.
  Future<void> upsertUserRating(int rating) async {
    final GameData data = hive.cachedRequests.get('${game.identifier}') ?? GameData(
      identifier: game.identifier,
      myRating: rating,
    );

    try {
      await database.upsertGameRating(game, rating);
      myRating.value = rating;
    }
    catch (error, stackTrace) {
      Logger.error.print(
        message: '$error',
        label: 'Details Controller | Upsert Rating',
        stackTrace: stackTrace,
      );
      return;
    }

    // Fetch and update total ratings count.
    try {
      data.totalRatings = await database.getGameRatingsCount(game);
      totalRatings.value = data.totalRatings!;
    }
    catch (error, stackTrace) {
      Logger.error.print(
        message: '$error',
        label: 'Details Controller | Total Ratings',
        stackTrace: stackTrace,
      );
      data.totalRatings = 0;
    }

    // Fetch and update average rating.
    try {
      data.averageRating = await database.getAverageRatingByGame(game);
      averageRating.value = data.averageRating!;
    }
    catch (error, stackTrace) {
      Logger.error.print(
        message: '$error',
        label: 'Details Controller | Average Rating',
        stackTrace: stackTrace,
      );
      data.averageRating = 0.0;
    }

    // Fetch and update individual star count.
    try {
      data.stars = await database.getGameRatingsByStarsCount(game);
      starsCount.value = data.stars!;
    }
    catch (error, stackTrace) {
      Logger.error.print(
        message: '$error',
        label: 'Details Controller | Ratings by Star',
        stackTrace: stackTrace,
      );
      data.stars = <String, int> {
        "5": 0,
        "4": 0,
        "3": 0,
        "2": 0,
        "1": 0,
      };
    }
  
    hive.cachedRequests.put(data);
  }

  /// Retrieves the current average rating of the specified game.
  /// 
  /// This method first attempts to fetch the average rating from the cache using the game's identifier. 
  /// If the value is not cached, it queries the database to retrieve the rating, handling any errors that might occur during the process by setting a default value of 0.0.
  /// The fetched or defaulted value is then stored in the cache for future use.
  Future<double> getAverageRating(Game game) async {
    final GameData data = hive.cachedRequests.get('${game.identifier}') ?? GameData(
      identifier: game.identifier,
    );
    try {
      data.averageRating ??= await database.getAverageRatingByGame(game);
    }
    catch (error, stackTrace) {
      Logger.error.print(
        message: "$error",
        label: "Search Controller | Average Rating",
        stackTrace: stackTrace,
      );
      data.averageRating = 0.0;
    }
    hive.cachedRequests.put(data);
    return data.averageRating!;
  }

  // INSTALLATION 🧩: =========================================================================================================================================================== //
  
  /// The current state of the installation process.
  ///
  /// This [ValueNotifier] is used to communicate the state of the installation process to the user.
  /// It is updated by the [getMIDlet] and [tryInstallMIDlet] functions.
  final ValueNotifier<ProgressEnumeration> installationState = ValueNotifier<ProgressEnumeration>(ProgressEnumeration.loading);

  /// The downloaded MIDlet, if any.
  ///
  /// This is a temporary variable that is used to store the downloaded MIDlet file.
  /// It is used by the [tryInstallMIDlet] function to install the MIDlet.
  late File? _midlet;

  /// Opens the GitHub repository for the emulator in the browser.
  ///
  /// This function is used to allow users to download the emulator from the official GitHub repository.
  Future<void> openGitHub() async => await activity.gitHub();

  /// Opens the Play Store to download the emulator.
  ///
  /// This function is used to allow users to download the emulator from the Google Play Store.
  Future<void> openPlayStore() async => await activity.playStore();

  /// Downloads the specified MIDlet from the bucket.
  ///
  /// This function is used to download the selected MIDlet from the bucket.
  /// It updates the [installationState] based on the result of the download operation.
  Future<void> getMIDlet() async {
    try {
      _midlet = await bucket.midlet(game.defaultMIDlet!);

      installationState.value = ProgressEnumeration.ready;
    }
    catch (error, stackTrace) {
      installationState.value = ProgressEnumeration.error;

      Logger.error.print(
        message: "$error",
        label: "Downloads | GET • MIDlet",
        stackTrace: stackTrace,
      );
    }
  }

  /// Installs the downloaded MIDlet using the emulator.
  ///
  /// This function is used to install the downloaded MIDlet using the emulator.
  /// It updates the [installationState] based on the result of the installation operation.
  Future<void> tryInstallMIDlet() async {
    try {
      if (_midlet == null) throw Exception("This game does not have a MIDLet available!");

      await activity.emulator(_midlet!);
    }
    on PlatformException catch (error, stackTrace) {
      installationState.value = ProgressEnumeration.emulatorNotFound;

      Logger.error.print(
        message: "$error",
        label: "Downloads | Install MIDlet",
        stackTrace: stackTrace,
      );
    }
    catch (error, stackTrace) {
      installationState.value = ProgressEnumeration.error;

      Logger.error.print(
        message: "$error",
        label: "Downloads | Install MIDlet",
        stackTrace: stackTrace,
      );
    }
  }
}