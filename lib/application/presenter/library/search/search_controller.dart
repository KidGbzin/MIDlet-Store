part of '../search/search_handler.dart';

class _Controller {

  // MARK: Constructor ⮟

  /// Manages cloud storage operations, including downloading and caching assets such as game previews and thumbnails.
  final BucketRepository rBucket;

  /// Manages local database operations, including storing game details, ratings, and user preferences.
  final HiveRepository rHive;

  /// Handles main database interactions, including fetching and updating game data, ratings, and related metadata.
  final SupabaseRepository rSupabase;

  /// Manages AdMob advertising operations, including loading, displaying, and disposing of banner and interstitial advertisementss.
  final AdMobService sAdMob;
  
  _Controller({
    required this.rBucket,
    required this.rHive,
    required this.rSupabase,
    required this.sAdMob,
  });

  /// The complete list of all games available, loaded from the database.
  ///
  /// This list contains all the games stored in the database, retrieved during the initialization of the controller.
  /// It is used as the base data for the games list.
  /// The list is immutable (`List.unmodifiable`), meaning it cannot be modified directly.
  /// Any filtering or updates to the list should be done through the `nCurrentGames` notifier.
  late final List<Game> _allGames;

  /// Initializes the handler’s core services and state notifiers.
  ///
  /// This method must be called from the `initState` of the handler widget.
  /// It prepares essential services and, if necessary, manages the initial navigation flow based on the current application state.
  Future<void> initialize({
    required String? publisher,
  }) async {
    try {
      nCurrentGames = ValueNotifier((<Game> [], true));
      nFiltersPublishers = ValueNotifier<Map<String,int>?>(null);
      nFiltersReleaseYear = ValueNotifier<Map<int, int>?>(null);
      nFiltersTags = ValueNotifier<List<(TagEnumeration, String, int)>?>(null);
      nSelectedPublisher = ValueNotifier<String?>(publisher);
      nSelectedReleaseYear = ValueNotifier<int?>(null);
      nSelectedTags = ValueNotifier(<String> []);

      final List<Game> games = await execute(() async {
        _allGames = List.unmodifiable(rHive.boxGames.all());

        if (nSelectedPublisher.value == null) {
          return _allGames;
        }
        else {
          return _allGames.where((game) => game.publisher == nSelectedPublisher.value).toList();
        }
      });

      nCurrentGames.value = (games, false);
      nSuggestions.value = rHive.boxRecentGames.all();
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );
    }
  }

  /// Disposes the handler’s resources and notifiers.
  ///
  /// This method must be called from the `dispose` method of the handler widget to ensure proper cleanup and prevent memory leaks.
  void dispose() {
    cTextField.dispose();

    nCurrentGames.dispose();
    nFiltersPublishers.dispose();
    nFiltersReleaseYear.dispose();
    nFiltersTags.dispose();
    nSelectedPublisher.dispose();
    nSelectedReleaseYear.dispose();
    nSelectedTags.dispose();
    nSuggestions.dispose();

    sAdMob.clear();
  }

  // MARK: Notifiers ⮟

  /// Notifier for the current list of games and its loading state.
  ///
  /// This notifier stores the current list of games and its loading state.
  /// It is used to update the UI when the list of games changes or when the loading state changes.
  late final ValueNotifier<(List<Game>, bool)> nCurrentGames;

  /// Holds a notifier with a map of unique publishers and their counts.
  late final ValueNotifier<Map<String, int>?> nFiltersPublishers;

  /// Holds a notifier with a map of unique release years and their counts.
  late final ValueNotifier<Map<int, int>?> nFiltersReleaseYear;

  /// Holds a notifier with a list of unique tags and their counts.
  late final ValueNotifier<List<(TagEnumeration, String, int)>?> nFiltersTags;

  /// The current publisher filter that is actively applied.
  ///
  /// This notifier holds the selected publisher filter.
  /// It is updated when a user selects a specific publisher to filter the list of games.
  /// If no publisher filter is applied, its value will be `null`.
  late final ValueNotifier<String?> nSelectedPublisher;

  /// The current release year filter that is actively applied.
  ///
  /// This notiifier holds the selected release year filter.
  /// It is updated when a user selects a specific year to filter the list of games.
  /// If no release year filter is applied, its value will be `null`.
  late final ValueNotifier<int?> nSelectedReleaseYear;

  /// The current tags applied to the filter.
  ///
  /// This notifier holds the list of active tags that the user has selected to filter the games by.
  /// Each item in the list represents a tag that is currently active in the filter.
  late final ValueNotifier<List<String>> nSelectedTags;

  // MARK: Advertisements ⮟

  // MARK: num sei ⮟

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
    nCurrentGames.value = (<Game> [], true);

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

    nCurrentGames.value = (games, false);

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
    nCurrentGames.value = (<Game> [], true);

    final List<Game> games = await execute(() async {
      cTextField.clear();

      nSelectedReleaseYear.value = null;
      nSelectedPublisher.value = null;
      nSelectedTags.value.clear();
      
      return _allGames;
    });

    nCurrentGames.value = (games, false);
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
    nCurrentGames.value = (<Game> [], true);

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

    nCurrentGames.value = (games, false);
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
      data.averageRating ??= await rSupabase.getAverageRatingForGame(game);
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      data.averageRating = 0.0;
    }

    try {
      data.downloads ??= await rSupabase.getOrInsertGameDownloads(game);
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
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
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      return Future.value(null);
    }
  }

  Future<File> getPublisherLogo(String title) => rBucket.publisher(title);
}