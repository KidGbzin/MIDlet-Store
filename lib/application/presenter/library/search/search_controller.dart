part of '../search/search_handler.dart';

class _Controller implements IController {

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
  late final List<Game> allGames;

  ActiveFilters activeFilters = ActiveFilters();

  @override
  Future<void> initialize() async {
    try {
      sAdMob.clear(Views.search);
      
      await execute(() async {
        allGames = List.unmodifiable(await rSembast.boxGames.all());
        nGames.value = allGames;
      });

      nProgress.value = (
        state: Progresses.isReady,
        error: null,
      );
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      nProgress.value = (
        state: Progresses.hasError,
        error: error,
      );
    }
  }

  @override
  void dispose() {
    nGames.dispose();
    nProgress.dispose();
    nSuggestions.dispose();
  }

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Notifiers ⮟

  /// A notifier that holds the current list of games based on the active filters or search.
  /// 
  /// This list is updated dynamically when filters are applied or the game data is fetched from the server.
  /// It serves as the main data source for game listings in the UI.
  final ValueNotifier<List<Game>> nGames = ValueNotifier(<Game> []);

  /// A notifier that holds the current loading state and any error encountered during operations.
  /// 
  /// It is used to reflect loading status (e.g., isLoading, isLoaded, isError) and provide error feedback to the user interface.
  final ValueNotifier<({
    Progresses state,
    Object? error,
  })> nProgress = ValueNotifier((
    state: Progresses.isLoading,
    error: null,
  ));

  /// A notifier that holds the current state of the game list.
  /// 
  /// It is used to reflect loading status (e.g., isLoading, isLoaded, isError) and provide error feedback to the user interface.
  final ValueNotifier<({
    Progresses state,
    Object? error,
  })> nListState = ValueNotifier((
    state: Progresses.isReady,
    error: null,
  ));

  /// A notifier that holds the list of recently viewed or recommended games.
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

  /// Applies the currently active filters to the list of games.
  ///
  /// This method filters the [allGames] list based on the active publisher and tag filters, and updates the [nGames] to reflect the filtered list.
  /// If no filters are applied, the list is reset to its original, unfiltered state.
  Future<void> onFiltersApply(ActiveFilters filters) async {
    final String? publisher = filters.publisher;
    final int? year = filters.year;
    final List<String> categories = filters.categories;

    nListState.value = (
      state: Progresses.isLoading,
      error: null,
    );

    final List<Game> collection = await execute(() async {
      return allGames.where((game) {
        final bool matchesPublisher = publisher == null || game.publisher == publisher;
        final bool matchesYear = year == null || game.release == year;
        final bool matchesTags = categories.isEmpty || categories.every((tag) => game.tags.contains(tag));

        return matchesPublisher && matchesTags && matchesYear;
      }).toList();
    });

    activeFilters = filters;
    nGames.value = collection;

    nListState.value = (
      state: Progresses.isReady,
      error: null,
    );

    Logger.information('Filters have been applied!');
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
    nListState.value = (
      state: Progresses.isLoading,
      error: null,
    );

    final List<Game> games = await execute(() async {
      query = query.toLowerCase();
  
      return allGames.where((element) {
        final String title = element.title.toLowerCase();
        final String release = element.release.toString();
        final String vendor = element.publisher.toLowerCase();

        return title.contains(query) ||
               release == query ||
               vendor.contains(query) ||
               element.tags.any((tag) => tag.toLowerCase() == query);
      }).toList();
    });

    nGames.value = games;
    nListState.value = (
      state: Progresses.isReady,
      error: null,
    );
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
  Future<GameMetadata> getGameMetadata(Game game) async {
    try {
      GameMetadata? metadata = await rSembast.boxCachedRequests.getMetadata(game.identifier);

      if (metadata == null) {
        metadata = await rSupabase.getGameMetadataForGame(game);
        
        await rSembast.boxCachedRequests.putMetadata(metadata);
      }

      return metadata;
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      return GameMetadata.empty(game.identifier);
    }
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