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
  late ValueNotifier<List<Game>> gameListState;

  /// Initializes the controller and loads the necessary data for games and suggestions.
  ///
  /// This method sets up the controller by loading all games from the database and initializes the notifiers for the game list and recent suggestions.
  Future<void> initialize({
    required String? publisher,
  }) async {
    selectedPublisherState = ValueNotifier(publisher);

    try {
      _allGames = List.unmodifiable(hive.games.all());

      if (selectedPublisherState.value == null) {
        gameListState = ValueNotifier(_allGames);
      }
      else {
        gameListState = ValueNotifier(_allGames.where((game) => game.publisher == selectedPublisherState.value).toList());
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
    gameListState.dispose();
    gemeSuggestionsList.dispose();
    selectedPublisherState.dispose();
    selectedTagsState.dispose();
    textController.dispose();
  }

  // FILTERS 🧩: ================================================================================================================================================================ //

  /// The current publisher filter that is actively applied.
  ///
  /// This [ValueNotifier] holds the selected publisher filter.
  /// It is updated when a user selects a specific publisher to filter the list of games.
  /// If no publisher filter is applied, its value will be `null`.
  late final ValueNotifier<String?> selectedPublisherState;

  /// The current release year filter that is actively applied.
  ///
  /// This [ValueNotifier] holds the selected release year filter.
  /// It is updated when a user selects a specific year to filter the list of games.
  /// If no release year filter is applied, its value will be `null`.
  late final ValueNotifier<int?> selectedReleaseYearState = ValueNotifier(null);

  /// The current tags applied to the filter.
  ///
  /// This [ValueNotifier] holds the list of active tags that the user has selected to filter the games by.
  /// Each item in the list represents a tag that is currently active in the filter.
  final ValueNotifier<List<String>> selectedTagsState = ValueNotifier(<String> []);

  /// Retrieves a list of all unique tags from the local game collection, along with their occurrence count.
  ///
  /// This function iterates through the local game collection and retrieves a list of all unique tags.
  /// Each tag is then paired with its occurrence count, which is the number of times the tag appears in the collection.
  /// The list is sorted in descending order by occurrence count.
  ///
  /// Returns a [List] of tuples, where each tuple contains:
  ///   1. A [TagEnumeration] representing the tag.
  ///   2. A [String] containing the localized name of the tag.
  ///   3. An [int] containing the occurrence count of the tag.
  List<(TagEnumeration, String, int)> getCategories(AppLocalizations localizations) {
    final List<(TagEnumeration, String, int)> categories = <(TagEnumeration, String, int)> [];
    final Map<String, int> table = <String, int>{};
  
    for (int index = 0; index < hive.games.length; index++) {
      final List<String> tags = hive.games.fromIndex(index).tags;

      for (final String tag in tags) {
        if (!table.containsKey(tag)) {
          table[tag] = 1;
        }
        else {
          table[tag] = table[tag]! + 1;
        }
      }
    }
  
    categories.addAll(
      table.entries.map((entry) {
        final TagEnumeration tag = TagEnumeration.fromCode(entry.key);
        return (tag, tag.fromLocale(localizations), entry.value);
      }),
    );
  
    categories.sort((x, y) => x.$2.compareTo(y.$2));
  
    return categories;
  }

  /// Retrieves a list of all unique game publishers from the local game collection.
  ///
  /// This function iterates through the local game collection and retrieves a list of all unique publishers.
  /// The list is then returned, which can be used to populate a list of publishers for the user to select from.
  ///
  /// Returns a [List] of strings, where each string represents a unique publisher.
  Map<String, int> getPublishers() {
    final Map<String, int> publishers = <String, int> {};

    for (int index = 0; index < hive.games.length; index ++) {
      final String publisher = hive.games.fromIndex(index).publisher;

      if (!publishers.containsKey(publisher)) {
        publishers[publisher] = 1;
      }
      else {
        publishers[publisher] = publishers[publisher]! + 1;
      }
    }
  
    final List<MapEntry<String, int>> publishersSorted = publishers.entries.toList();

    publishersSorted.sort((MapEntry<String, int> x, MapEntry<String, int> y) => y.value.compareTo(x.value));

    return Map.fromEntries(publishersSorted);
  }

  /// Retrieves a list of all unique release years from the local game collection.
  ///
  /// This function iterates through the local game collection and retrieves a list of all unique release years.
  /// The list is then returned, which can be used to populate a list of release years for the user to select from.
  ///
  /// Returns a [List] of integers, where each integer represents a unique release year.
  Map<int, int> getReleaseYears() {
    final Map<int, int> years = <int, int> {};

    for (int index = 0; index < hive.games.length; index ++) {
      final int year = hive.games.fromIndex(index).release;

      if (!years.containsKey(year)) {
        years[year] = 1;
      }
      else {
        years[year] = years[year]! + 1;
      }
    }

    final List<MapEntry<int, int>> yearsSorted = years.entries.toList()..sort((x, y) => x.key.compareTo(y.key));

    return Map.fromEntries(yearsSorted);
  }

  /// Applies the currently active filters to the list of games.
  ///
  /// This method filters the [_allGames] list based on the active publisher and tag filters, and updates the [gameListState] to reflect the filtered list.
  /// It is typically used after the user finishes selecting filters in the [ModalWidget] widget.
  /// If no filters are applied, the list is reset to its original, unfiltered state.
  void applyFilters(BuildContext context, AppLocalizations localizations) {
    textController.clear();

    gameListState.value = _allGames.where((game) {
      final bool matchesPublisher = selectedPublisherState.value == null || game.publisher == selectedPublisherState.value;
      final bool matchesReleaseYear = selectedReleaseYearState.value == null || game.release == selectedReleaseYearState.value;
      final bool matchesTags = selectedTagsState.value.isEmpty || selectedTagsState.value.every((tag) => game.tags.contains(tag));

      return matchesPublisher && matchesTags && matchesReleaseYear;
    }).toList();

    final String message;

    if (selectedPublisherState.value == null && selectedTagsState.value.isEmpty && selectedReleaseYearState.value == null) {
      message = localizations.messageFiltersEmpty.replaceFirst('\$1', '${hive.games.length}');
    }

    else {
      message = localizations.messageFiltersApplied.replaceAllMapped(RegExp(r'\$1|\$2'), (match) {
        return <String, String> {
          "\$1": gameListState.value.length.toString(),
          "\$2": hive.games.length.toString(),
        } [match[0]]!;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(MessengerExtension(
      message: message,
      icon: HugeIcons.strokeRoundedFilter,
    ));
  }

  /// Clears all active filters applied to the games list.
  ///
  /// This method resets the state of the game list and its filters, returning the list to its unfiltered state.
  void clearFilters(BuildContext context, AppLocalizations localizations, bool showMessage) {
    gameListState.value = _allGames;
    selectedPublisherState.value = null;
    selectedTagsState.value.clear();
    selectedReleaseYearState.value = null;
    textController.clear();

    if (showMessage) {
      final String message = localizations.messageFiltersCleared.replaceAllMapped(RegExp(r'\$1'), (match) => hive.games.length.toString());

      ScaffoldMessenger.of(context).showSnackBar(MessengerExtension(
        message: message,
        icon: HugeIcons.strokeRoundedFilterRemove,
      ));
    }
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
  
    gameListState.value = _allGames.where((element) {
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