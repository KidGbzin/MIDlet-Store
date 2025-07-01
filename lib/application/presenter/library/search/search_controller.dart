part of '../search/search_handler.dart';

class _Controller {

  /// Manages cloud storage operations, including downloading and caching assets such as game previews and thumbnails.
  final BucketRepository rBucket;

  /// Manages local storage operations, including games, favorites, recent games, and cached requests.
  final SembastRepository rSembast;

  /// Handles main database interactions, including fetching and updating game data, ratings, and related metadata.
  final SupabaseRepository rSupabase;

  /// Manages AdMob advertising operations, including loading, displaying, and disposing of banner and interstitial advertisementss.
  final AdMobService sAdMob;

  _Controller({
    required this.rBucket,
    required this.rSembast,
    required this.rSupabase,
    required this.sAdMob,
  });

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Initialization ⮟

  /// The complete list of all games available, loaded from the database.
  ///
  /// This list contains all the games stored in the database, retrieved during the initialization of the controller.
  /// It is used as the base data for the games list.
  /// The list is immutable (`List.unmodifiable`), meaning it cannot be modified directly.
  /// Any filtering or updates to the list should be done through the [nGames] notifier.
  late final List<Game> _allGames;

  /// Initializes the handler’s core services and state notifiers.
  ///
  /// This method must be called from the `initState` of the handler widget.
  /// It prepares essential services and, if necessary, manages the initial navigation flow based on the current application state.
  Future<void> initialize() async {
    try {
      sAdMob.clear(Views.search);
      
      await execute(() async {
        _allGames = List.unmodifiable(await rSembast.boxGames.all());
        nGames.value = _allGames;
      });

      nProgress.value = (Progresses.isFinished, null);
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      nProgress.value = (Progresses.hasError, error);
    }
  }

  /// Disposes the handler’s resources and notifiers.
  ///
  /// This method must be called from the `dispose` method of the handler widget to ensure proper cleanup and prevent memory leaks.
  void dispose() {
    nFilters.dispose();
    nGames.dispose();
    nProgress.dispose();
    nSelectedFilters.dispose();
    nSuggestions.dispose();
  }

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Notifiers ⮟

  /// A [ValueNotifier] that holds the current list of games based on the active filters or search.
  /// 
  /// This list is updated dynamically when filters are applied or the game data is fetched from the server.
  /// It serves as the main data source for game listings in the UI.
  final ValueNotifier<List<Game>> nGames = ValueNotifier(<Game> []);

  /// A [ValueNotifier] that holds all available filters for the game list.
  /// 
  /// This includes the list of categories (with their enum, name, and count), publishers (with count), and years (with count).
  /// It is updated when fetching metadata and used to populate filtering options in the UI.
  final ValueNotifier<({
    List<(TagEnumeration, String, int)> categories,
    Map<String, int> publishers,
    Map<int, int> years,
  })> nFilters = ValueNotifier((
    categories: <(TagEnumeration, String, int)> [],
    publishers: <String, int> {},
    years: <int, int> {},
  ));

  /// A [ValueNotifier] that holds the current loading state and any error encountered during operations.
  /// 
  /// It is used to reflect loading status (e.g., isLoading, isLoaded, isError) and provide error feedback to the user interface.
  final ValueNotifier<(Progresses progress, Object? error)> nProgress = ValueNotifier((Progresses.isLoading, null));

  /// A [ValueNotifier] that holds the currently selected filters for the game list.
  /// 
  /// This includes the selected category names, publisher, and year. It is used to filter the list of games shown to the user.
  final ValueNotifier<({
    List<String> categories,
    String? publisher,
    int? year,
  })> nSelectedFilters = ValueNotifier((
    categories: <String> [],
    publisher: null,
    year: null,
  ));

  /// A [ValueNotifier] that holds the list of recently viewed or recommended games.
  ///
  /// This notifier is used to display the most recent games that the user has interacted with, or suggestions based on user activity.
  /// It can be used to show a "recently viewed" section when searching a game.
  final ValueNotifier<List<Game>> nSuggestions = ValueNotifier(<Game> []);

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Advertisements ⮟

  BannerAd? getAdvertisementByIndex(int index) => sAdMob.getAdvertisementByIndex(index, Views.search);

  void preloadNearbyAdvertisements(int index) => sAdMob.preloadNearbyAdvertisements(
    iCurrent: index,
    size: AdSize.mediumRectangle,
    view: Views.search,
  );

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Filters ⮟

  /// Extracts and prepares the available filter options (tags, publishers, years) from the local game collection.
  ///
  /// This method analyzes the [collection] of games and extracts three categories of filters:
  ///   1. **Tags**: A list of unique [TagEnumeration]s, each with its localized name and occurrence count.
  ///   2. **Publishers**: A map of publisher names and how many games each published.
  ///   3. **Years**: A map of release years and the number of games released in each year.
  ///
  /// All data is aggregated in a single pass through the game list for performance.
  ///
  /// This is used to dynamically populate filter options in the UI.
  void fetchFilters(AppLocalizations l10n) {
    if (nFilters.value.categories.isNotEmpty || nFilters.value.publishers.isNotEmpty || nFilters.value.years.isNotEmpty) return;

    final List<(TagEnumeration, String, int)> categories = <(TagEnumeration, String, int)> [];
    final Map<String, int> publishers = <String, int> {};
    final Map<int, int> years = <int, int> {};
    
    final Map<String, int> table = <String, int> {};
    
    // Iterate through the collection, counting the occurrences of each filter.
    // This loop was refactored to reduce the number of iterations that was used to retrieve the filters.
    for (int index = 0; index < _allGames.length; index ++) {
      final String publisher = _allGames[index].publisher;
      final List<String> tags = _allGames[index].tags;
      final int year = _allGames[index].release;
    
      // Count the occurrences of games by year.
      if (!years.containsKey(year)) {
        years[year] = 1;
      }
      else {
        years[year] = years[year]! + 1;
      }
    
      // Count the occurrences of games by publisher.
      if (!publishers.containsKey(publisher)) {
        publishers[publisher] = 1;
      }
      else {
        publishers[publisher] = publishers[publisher]! + 1;
      }
    
      // Count the occurrences of games by tag.
      for (int iTag = 0; iTag < tags.length; iTag ++) {
        final String tag = tags[iTag];
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
        return (tag, tag.fromLocale(l10n), entry.value);
      }),
    );
    
    // Sort the filters alphabetically, making easier to the user to find the desired filter.
    categories.sort((x, y) => x.$2.compareTo(y.$2));
    final List<MapEntry<int, int>> sortedYears = years.entries.toList()..sort((x, y) => x.key.compareTo(y.key));
    final List<MapEntry<String, int>> sortedPublishers = publishers.entries.toList()..sort((x, y) => y.value.compareTo(x.value));
    
    nFilters.value = (
      categories: categories,
      publishers: Map.fromEntries(sortedPublishers),
      years: Map.fromEntries(sortedYears),
    );
  }

  /// Applies the currently active filters to the list of games.
  ///
  /// This method filters the [_allGames] list based on the active publisher and tag filters, and updates the [nGames] to reflect the filtered list.
  /// If no filters are applied, the list is reset to its original, unfiltered state.
  Future<void> applyFilters(BuildContext context, AppLocalizations localizations) async {
    nProgress.value = (Progresses.isLoading, null);

    final List<Game> collection = await execute(() async {
      final ({List<String> categories, String? publisher, int? year}) record = nSelectedFilters.value;

      return _allGames.where((game) {
        final bool matchesPublisher = record.publisher == null || game.publisher == record.publisher;
        final bool matchesYear = record.year == null || game.release == record.year;
        final bool matchesTags = record.categories.isEmpty || record.categories.every((tag) => game.tags.contains(tag));

        return matchesPublisher && matchesTags && matchesYear;
      }).toList();
    });

    nGames.value = collection;
    nProgress.value = (Progresses.isFinished, null);
  }

  /// This method resets the state of the game list and its filters, returning the list to its unfiltered state.
  Future<void> clearFilters() async {
    nProgress.value = (Progresses.isLoading, null);

    final List<Game> collection = await execute(() async {
      nSelectedFilters.value = (
        categories: <String> [],
        publisher: null,
        year: null,
      );
      
      return _allGames;
    });

    nGames.value = collection;
    nProgress.value = (Progresses.isFinished, null);
  }

  void updateSelectedFilters({
    List<String>? categories,
    String? publisher,
    int? year,
  }) {
    final ({List<String> categories, String? publisher, int? year}) record = nSelectedFilters.value;

    nSelectedFilters.value = (
      categories: categories ?? record.categories,
      publisher: publisher ?? record.publisher,
      year: year ?? record.year,
    );
  }

  // MARK: -------------------------
  // 
  //  
  // 
  // MARK: Search ⮟

  /// The text editing controller for managing user input text.
  /// 
  /// This controller is used to manage the input from text fields in the UI, allowing the user to type search queries or other textual data.
  /// It provides methods for retrieving, modifying, and clearing the input text.
  final TextEditingController cTextField = TextEditingController();

  

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
    nProgress.value = (Progresses.isLoading, null);

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

    nGames.value = (games);
    nProgress.value = (Progresses.isFinished, null);
  }

  // MARK: -------------------------
  // 
  //  
  // 
  // MARK: Database ⮟

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
  Future<Map<String, dynamic>> getGameMetadata(Game game) async {
    final GameMetadata data = await rSembast.boxCachedRequests.get(game.identifier) ?? GameMetadata(
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
      data.downloads ??= await rSupabase.getOrInsertDownloadsForGame(game);
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      data.downloads = 0;
    }

    rSembast.boxCachedRequests.put(data);

    return <String, dynamic> {
      "Average-Rating": data.averageRating,
      "Downloads": data.downloads,
    };
  }

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Storage ⮟

  /// Retrieves a [Future] that resolves to a thumbnail [File] for a given game title.
  ///
  /// This method fetches the cover image file from the bucket storage using the provided [title].
  Future<File?> getThumbnail(String title) {
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

  /// Retrieves a [Future] that resolves to a publisher logo [File] for a given game title.
  ///
  /// This method fetches the publisher logo image file from the bucket storage using the provided [title].
  Future<File> getPublisherLogo(String title) => rBucket.publisher(title);

  // MARK: -------------------------
  // 
  //  
  // 
  // MARK: Helpers ⮟

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
}