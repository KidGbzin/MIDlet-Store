part of '../search/search_handler.dart';

// SEARCH CONTROLLER 🧩: ======================================================================================================================================================== //

/// Controller for managing game-related data and interactions.
///
/// This controller is responsible for managing the game's data, including fetching, updating, and storing game list information.
/// It interacts with external services like the bucket, database, and local database to perform necessary operations.
class _Controller {
  
  _Controller({
    required this.bucket,
    required this.database,
    required this.hive,
  });

  /// A repository for managing data retrieval and storage within the bucket.
  ///
  /// Responsible for handling interactions with external storage systems, including retrieving and caching assets such as game previews and thumbnails.
  late final BucketRepository bucket;

  /// Local database service for data operations.
  /// 
  /// Manages local data, such as game details, ratings, and user preferences.
  late final HiveRepository hive;

  /// The database service for handling broader data interactions.
  /// 
  /// This service interacts with the main database.
  /// Responsible for fetching and updating game data, including average ratings, game details, and other important game-related information.
  late final SupabaseRepository database;

  /// The complete list of all games available, loaded from the database.
  ///
  /// This list contains all the games stored in the database, retrieved during the initialization of the controller.
  /// It is used as the base data for the games list.
  /// The list is immutable (`List.unmodifiable`), meaning it cannot be modified directly.
  /// Any filtering or updates to the list should be done through the `currentlyActiveGameList` notifier.
  late final List<Game> _allGames;
  
  /// A [ValueNotifier] that holds the current list of games to be displayed.
  ///
  /// This notifier is used to track and update the list of games that should be shown in the UI.
  /// It can be modified when applying filters or updating the list of games, and any changes will automatically trigger UI updates.
  late ValueNotifier<List<Game>> currentlyActiveGameList;

  /// Initializes the controller and loads the necessary data for games and suggestions.
  ///
  /// This method sets up the controller by loading all games from the database and initializes the notifiers for the game list and recent suggestions.
  Future<void> initialize({
    required String? publisher,
  }) async {
    publisherState = ValueNotifier(publisher);

    try {
      _allGames = List.unmodifiable(hive.games.all());

      if (publisherState.value == null) {
        currentlyActiveGameList = ValueNotifier(_allGames);
      }
      else {
        currentlyActiveGameList = ValueNotifier(_allGames.where((game) => game.publisher == publisherState.value).toList());
      }
      
      gemeSuggestionsList = ValueNotifier(hive.recentGames.all());
    }
    catch (error, stackTrace) {
      Logger.error.print(
        label: 'Search Controller | Initialize',
        message: '$error',
        stackTrace: stackTrace,
      );
    }
  }

  /// Discards the resources used by the controller and cleans up allocated memory.
  ///
  /// This method is called to release the resources and memory allocated by the controller when it is no longer needed.
  /// It disposes of all [ValueNotifier] instances and controllers that the controller is using to avoid memory leaks.
  void dispose() {
    currentlyActiveGameList.dispose();
    gemeSuggestionsList.dispose();
    publisherState.dispose();
    tagsState.dispose();
    textController.dispose();
  }

  // FILTERS 🧩: ================================================================================================================================================================ //

  /// The current publisher filter that is actively applied.
  ///
  /// This [ValueNotifier] holds the selected publisher filter.
  /// It is updated when a user selects a specific publisher to filter the list of games.
  /// If no publisher filter is applied, its value will be `null`.
  late final ValueNotifier<String?> publisherState;

  /// The current tags applied to the filter.
  ///
  /// This [ValueNotifier] holds the list of active tags that the user has selected to filter the games by.
  /// Each item in the list represents a tag that is currently active in the filter.
  final ValueNotifier<List<String>> tagsState = ValueNotifier(<String> []);

  /// Applies the currently active filters to the list of games.
  ///
  /// This method filters the [_allGames] list based on the active publisher and tag filters, and updates the [currentlyActiveGameList] to reflect the filtered list.
  /// It is typically used after the user finishes selecting filters in the [ModalWidget] widget.
  void applyFilters() {
    textController.clear();
    currentlyActiveGameList.value = _allGames.where((element) {
      final bool matchesPublisher = publisherState.value == null ||  
                                    element.publisher == publisherState.value;

      final bool matchesTags = tagsState.value.isEmpty ||
                               tagsState.value.every((tag) => element.tags.contains(tag));

      return matchesPublisher && matchesTags;
    }).toList();
  }

  /// Clears all active filters applied to the games list.
  ///
  /// This method resets the state of the game list and its filters, returning the list to its unfiltered state.
  void clearFilters() {
    currentlyActiveGameList.value = _allGames;
    publisherState.value = null;
    tagsState.value.clear();
    textController.clear();
  }

  // SEARCH 🧩: ================================================================================================================================================================= //

  /// The text editing controller for managing user input text.
  /// 
  /// This controller is used to manage the input from text fields in the UI, allowing the user to type search queries or other textual data.
  /// It provides methods for retrieving, modifying, and clearing the input text.
  final TextEditingController textController = TextEditingController();

  /// A [ValueNotifier] that holds the list of recently viewed or recommended games.
  ///
  /// This notifier is used to display the most recent games that the user has interacted with, or suggestions based on user activity.
  /// It can be used to show a "recently viewed" section when searching a game.
  late final ValueNotifier<List<Game>> gemeSuggestionsList;

  /// The global key used to manage the overlay in the widget tree.
  /// 
  /// This key controls the overlay, which is used to display game suggestions when the user taps on the text form.
  late GlobalKey overlayKey;

  /// Filters the games list based on a search query.
  /// 
  /// The search is performed by checking if the query appears in any of the following fields:
  /// - If the game's title contains [query].
  /// - If the game's year of release is equal to [query].
  /// - If the game's vendor contains [query].
  /// - If any tag matches the [query].
  void applySearch(String query) {
    query = query.toLowerCase();
  
    currentlyActiveGameList.value = _allGames.where((element) {
      final String title = element.title.toLowerCase();
      final String release = element.release.toString();
      final String vendor = element.publisher.toLowerCase();

      return title.contains(query) ||
             release == query ||
             vendor.contains(query) ||
             element.tags.any((tag) => tag.toLowerCase() == query);
    }).toList();
  }

  // DATABASE 🧩: =============================================================================================================================================================== //

  /// Retrieves and caches the game data, including the average rating and download count, from the database.
  /// 
  /// This method attempts to fetch the game’s average rating and download count.
  /// If the data is not available in the cache, it queries the database to retrieve the values.
  /// 
  /// In case of any errors during the process, default values are assigned:
  /// - The average rating is set to `0.0` if not found or an error occurs.
  /// - The download count is set to `0` if not found or an error occurs.
  /// 
  /// After successfully retrieving or defaulting the values, the data is cached for future use.
  ///
  /// Returns a [Map<String, dynamic>] containing the following values:
  /// - `Average-Rating`: The average rating of the game.
  /// - `Downloads`: The total number of downloads for the game.
  Future<Map<String, dynamic>> getGameData(Game game) async {
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

    try {
      data.downloads ??= await database.getOrInsertGameDownloads(game);
    }
    catch (error, stackTrace) {
      Logger.error.print(
        message: "$error",
        label: "Search Controller | Average Rating",
        stackTrace: stackTrace,
      );
      data.downloads = 0;
    }

    hive.cachedRequests.put(data);

    return <String, dynamic> {
      "Average-Rating": data.averageRating,
      "Downloads": data.downloads,
    };
  }
  
  // BUCKET 🧩: ================================================================================================================================================================= //

  /// Retrieves a [Future] that resolves to a thumbnail [File] for a given game title.
  ///
  /// This method fetches the cover image file from the bucket storage using the provided [title].
  Future<File?> getCover(String title) {
    try {
      return bucket.cover(title);
    }
    catch (error, stackTrace) {
      Logger.error.print(
        message: "$error",
        label: "Search Controller | Cover",
        stackTrace: stackTrace,
      );

      return Future.value(null);
    }
  }
}