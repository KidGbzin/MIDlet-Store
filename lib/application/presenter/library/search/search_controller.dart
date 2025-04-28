part of '../search/search_handler.dart';

// SEARCH CONTROLLER 🔍: ======================================================================================================================================================== //

/// Controller for managing game-related data and interactions.
///
/// This controller is responsible for managing the game's data, including fetching, updating, and storing game list information.
/// It interacts with external services like the bucket, database, and local database to perform necessary operations.
class _Controller {
  
  _Controller({
    required this.rBucket,
    required this.rSupabase,
    required this.rHive,
  });

  /// A repository for managing data retrieval and storage within the bucket.
  ///
  /// Responsible for handling interactions with external storage systems, including retrieving and caching assets such as game previews and thumbnails.
  late final BucketRepository rBucket;

  /// Local database service for data operations.
  /// 
  /// Manages local data, such as game details, ratings, and user preferences.
  late final HiveRepository rHive;

  /// The database service for handling broader data interactions.
  /// 
  /// This service interacts with the main database.
  /// Responsible for fetching and updating game data, including average ratings, game details, and other important game-related information.
  late final SupabaseRepository rSupabase;

  /// The complete list of all games available, loaded from the database.
  ///
  /// This list contains all the games stored in the database, retrieved during the initialization of the controller.
  /// It is used as the base data for the games list.
  /// The list is immutable (`List.unmodifiable`), meaning it cannot be modified directly.
  /// Any filtering or updates to the list should be done through the `currentlyActiveGameList` notifier.
  late final List<Game> _allGames;

  /// The current publisher filter that is actively applied.
  ///
  /// This notifier holds the selected publisher filter.
  /// It is updated when a user selects a specific publisher to filter the list of games.
  /// If no publisher filter is applied, its value will be `null`.
  final ValueNotifier<String?> nSelectedPublisher = ValueNotifier(null);

  /// The current release year filter that is actively applied.
  ///
  /// This notiifier holds the selected release year filter.
  /// It is updated when a user selects a specific year to filter the list of games.
  /// If no release year filter is applied, its value will be `null`.
  final ValueNotifier<int?> nSelectedReleaseYear = ValueNotifier(null);

  /// The current tags applied to the filter.
  ///
  /// This notifier holds the list of active tags that the user has selected to filter the games by.
  /// Each item in the list represents a tag that is currently active in the filter.
  final ValueNotifier<List<String>> nSelectedTags = ValueNotifier(<String> []);

  /// Notifier for the filters of publishers.
  /// 
  /// This notifier holds the map of unique publishers and their respective counts.
  final ValueNotifier<Map<String, int>?> nFiltersPublishers = ValueNotifier(null);

  /// Notifier for the filters of release years.
  /// 
  /// This notifier holds the map of unique release years and their respective counts.
  final ValueNotifier<Map<int, int>?> nFiltersReleaseYear = ValueNotifier(null);

  /// Notifier for the filters of tags.
  /// 
  /// This notifier holds the list of unique tags and their respective counts.
  final ValueNotifier<List<(TagEnumeration, String, int)>?> nFiltersTags = ValueNotifier(null);

  /// Notifier for the current list of games and its loading state.
  ///
  /// This notifier stores the current list of games and its loading state.
  /// It is used to update the UI when the list of games changes or when the loading state changes.
  final ValueNotifier<(List<Game>, bool)> nGames = ValueNotifier((<Game> [], true));

  /// Initializes the controller and loads the necessary data for games and suggestions.
  ///
  /// This method sets up the controller by loading all games from the database and initializing the notifiers for the game list and recent suggestions.
  /// It also filters games by the specified publisher if provided.
  Future<void> initialize({
    required String? publisher,
  }) async {
    Logger.information.log("Initializing the Search controller...");

    nSelectedPublisher.value = publisher;

    try {
      final List<Game> games = await execute(() async {
        _allGames = List.unmodifiable(rHive.boxGames.all());

        if (nSelectedPublisher.value == null) {
          return _allGames;
        }
        else {
          return _allGames.where((game) => game.publisher == nSelectedPublisher.value).toList();
        }
      });

      nGames.value = (games, false);
      nSuggestions.value = rHive.boxRecentGames.all();
    }
    catch (error, stackTrace) {
      Logger.error.log(
        "$error",
        stackTrace: stackTrace,
      );
    }
  }

  /// Waits for the specified [operation] to complete and then waits for the minimum time minus the elapsed time.
  ///
  /// This method is used to prevent the UI from freezing due to frequent updates of the search results.
  /// It runs the [operation] and waits for the minimum time minus the time it took for the operation to complete.
  /// If the operation takes longer than the minimum time, this method returns immediately.
  ///
  /// The [minimumTime] parameter specifies the minimum time in milliseconds that the method should take to complete.
  /// If not specified, it defaults to 1000 milliseconds (1 second).
  ///
  /// Returns the result of the [operation].
  Future<T> execute<T>(Future<T> Function() operation, {int minimumTime = 1000}) async {
    final Stopwatch watch = Stopwatch()..start();

    T result = await operation();

    final int elapsedTime = watch.elapsedMilliseconds;
    final int availableTime = minimumTime - elapsedTime;

    if (availableTime > 0) {
      await Future.delayed(Duration(
        milliseconds: availableTime,
      ));
    }

    watch.stop();

    return result;
  }

  /// Discards the resources used by the controller and cleans up allocated memory.
  ///
  /// This method is called to release the resources and memory allocated by the controller when it is no longer needed.
  /// It disposes of all [ValueNotifier] instances and controllers that the controller is using to avoid memory leaks.
  void dispose() {
    Logger.information.log("Disposing the Search controller resources...");

    nGames.dispose();
    nSuggestions.dispose();
    nSelectedPublisher.dispose();
    nSelectedReleaseYear.dispose();
    nSelectedTags.dispose();
  
    cTextField.dispose();
  }

  // FILTERS RELATED 🏷️: ======================================================================================================================================================== //

  /// Retrieves a list of all unique tags from the local game collection, along with their occurrence count.
  ///
  /// This function iterates through the local game collection and retrieves a list of all unique tags.
  /// Each tag is then paired with its occurrence count, which is the number of times the tag appears in the collection.
  /// The list is sorted in descending order by occurrence count.
  ///
  /// Set the [nFiltersTags] of tuples, where each tuple contains:
  ///   1. A [TagEnumeration] representing the tag.
  ///   2. A [String] containing the localized name of the tag.
  ///   3. An [int] containing the occurrence count of the tag.
  ///
  /// This method is used to populate a list of tags for the user to select from.
  void fetchFiltersTags(AppLocalizations localizations) {
    if (nFiltersTags.value != null) return;

    final List<(TagEnumeration, String, int)> categories = <(TagEnumeration, String, int)> [];
    final Map<String, int> table = <String, int>{};
  
    for (int index = 0; index < rHive.boxGames.length; index++) {
      final List<String> tags = rHive.boxGames.fromIndex(index).tags;
  
      for (int tagIndex = 0; tagIndex < tags.length; tagIndex++) {
        final String tag = tags[tagIndex];
  
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
  
    nFiltersTags.value = categories;
  }

  /// Retrieves a list of all unique game publishers from the local game collection.
  ///
  /// This function iterates through the local game collection and retrieves a list of all unique publishers.
  /// The list is then set into the [nFiltersPublishers] notifier, which can be used to populate a list of publishers for the user to select from.
  ///
  /// The publishers are sorted in descending order by occurrence count.
  void fetchFiltersPublishers() {
    if (nFiltersPublishers.value != null) return;

    final Map<String, int> publishers = <String, int> {};

    for (int index = 0; index < rHive.boxGames.length; index ++) {
      final String publisher = rHive.boxGames.fromIndex(index).publisher;

      if (!publishers.containsKey(publisher)) {
        publishers[publisher] = 1;
      }
      else {
        publishers[publisher] = publishers[publisher]! + 1;
      }
    }
  
    final List<MapEntry<String, int>> publishersSorted = publishers.entries.toList();

    publishersSorted.sort((MapEntry<String, int> x, MapEntry<String, int> y) => y.value.compareTo(x.value));

    nFiltersPublishers.value = Map.fromEntries(publishersSorted);
  }

  /// Retrieves a list of all unique release years from the local game collection.
  ///
  /// This function iterates through the local game collection and retrieves a list of all unique release years.
  /// The list is then set into the [nFiltersReleaseYear], which can be used to populate a list of release years for the user to select from.
  void fetchFiltersReleaseYear() {
    if (nFiltersReleaseYear.value != null) return;

    final Map<int, int> years = <int, int> {};

    for (int index = 0; index < rHive.boxGames.length; index ++) {
      final int year = rHive.boxGames.fromIndex(index).release;

      if (!years.containsKey(year)) {
        years[year] = 1;
      }
      else {
        years[year] = years[year]! + 1;
      }
    }

    final List<MapEntry<int, int>> yearsSorted = years.entries.toList()..sort((x, y) => x.key.compareTo(y.key));

    nFiltersReleaseYear.value = Map.fromEntries(yearsSorted);
  }

  /// Applies the currently active filters to the list of games.
  ///
  /// This method filters the [_allGames] list based on the active publisher and tag filters, and updates the [gameListState] to reflect the filtered list.
  /// It is typically used after the user finishes selecting filters in the [ModalWidget] widget.
  /// If no filters are applied, the list is reset to its original, unfiltered state.
  Future<void> applyFilters(BuildContext context, AppLocalizations localizations) async {
    nGames.value = (<Game> [], true);

    final List<Game> games = await execute(() async {
      cTextField.clear();

      return _allGames.where((game) {
        final bool matchesPublisher = nSelectedPublisher.value == null || game.publisher == nSelectedPublisher.value;
        final bool matchesReleaseYear = nSelectedReleaseYear.value == null || game.release == nSelectedReleaseYear.value;
        final bool matchesTags = nSelectedTags.value.isEmpty || nSelectedTags.value.every((tag) => game.tags.contains(tag));

        return matchesPublisher && matchesTags && matchesReleaseYear;
      }).toList();
    });

    final String message;

    if (nSelectedPublisher.value == null && nSelectedTags.value.isEmpty && nSelectedReleaseYear.value == null) {
      message = localizations.messageFiltersEmpty.replaceFirst('\$1', '${rHive.boxGames.length}');
    }

    else {
      message = localizations.messageFiltersApplied.replaceAllMapped(RegExp(r'\$1|\$2'), (match) {
        return <String, String> {
          "\$1": games.length.toString(),
          "\$2": rHive.boxGames.length.toString(),
        } [match[0]]!;
      });
    }

    nGames.value = (games, false);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(MessengerExtension(
        message: message,
        icon: HugeIcons.strokeRoundedFilter,
      ));
    }
  }

  /// Clears all active filters applied to the games list.
  ///
  /// This method resets the state of the game list and its filters, returning the list to its unfiltered state.
  Future<void> clearFilters(BuildContext context, AppLocalizations localizations) async {
    nGames.value = (<Game> [], true);

    final List<Game> games = await execute(() async {
      cTextField.clear();

      nSelectedReleaseYear.value = null;
      nSelectedPublisher.value = null;
      nSelectedTags.value.clear();
      
      return _allGames;
    });

    nGames.value = (games, false);
  }

  // SEARCH RELATED 🔍: ========================================================================================================================================================= //

  /// The text editing controller for managing user input text.
  /// 
  /// This controller is used to manage the input from text fields in the UI, allowing the user to type search queries or other textual data.
  /// It provides methods for retrieving, modifying, and clearing the input text.
  final TextEditingController cTextField = TextEditingController();

  /// A [ValueNotifier] that holds the list of recently viewed or recommended games.
  ///
  /// This notifier is used to display the most recent games that the user has interacted with, or suggestions based on user activity.
  /// It can be used to show a "recently viewed" section when searching a game.
  final ValueNotifier<List<Game>> nSuggestions = ValueNotifier(<Game> []);

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
  Future<void> applySearch(String query) async {
    nGames.value = (<Game> [], true);

    final List<Game> games = await execute(() async {
      query = query.toLowerCase();
  
      return _allGames.where((element) {
        final String title = element.title.toLowerCase();
        final String release = element.release.toString();
        final String vendor = element.publisher.toLowerCase();

        return title.contains(query) ||
               release == query ||
               vendor.contains(query) ||
               element.tags.any((tag) => tag.toLowerCase() == query);
      }).toList();
    });

    nGames.value = (games, false);
  }

  // DATABASE RELATED 🗃️: ======================================================================================================================================================= //

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
    final GameData data = rHive.boxCachedRequests.get('${game.identifier}') ?? GameData(
      identifier: game.identifier,
    );

    try {
      data.averageRating ??= await rSupabase.getAverageRatingByGame(game);
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
      data.downloads ??= await rSupabase.getOrInsertGameDownloads(game);
    }
    catch (error, stackTrace) {
      Logger.error.print(
        message: "$error",
        label: "Search Controller | Average Rating",
        stackTrace: stackTrace,
      );
      data.downloads = 0;
    }

    rHive.boxCachedRequests.put(data);

    return <String, dynamic> {
      "Average-Rating": data.averageRating,
      "Downloads": data.downloads,
    };
  }
  
  // BUCKET RELATED 📦: ================================================================================================================================================================= //

  /// Retrieves a [Future] that resolves to a thumbnail [File] for a given game title.
  ///
  /// This method fetches the cover image file from the bucket storage using the provided [title].
  Future<File?> getCover(String title) {
    try {
      return rBucket.cover(title);
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

  Future<File> getPublisherLogo(String title) => rBucket.publisher(title);
}