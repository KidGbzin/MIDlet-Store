part of '../search/search_handler.dart';

class _Controller {
  
  _Controller({
    required this.bucket,
    required this.database,
  });

  /// The bucket service for fetching and storing data.
  late final IBucket bucket;

  /// The database service for data operations.
  late final IDatabase database;

  /// Initializes the controller and fetches the necessary data using a game [title] as a key to display its data.
  /// 
  /// While the controller is fetching data, it updates the state of its [progress].
  final ValueNotifier<Progress> progress = ValueNotifier(Progress.loading);

  final TextEditingController textController = TextEditingController();

  late GlobalKey overlayKey;

  late final List<Game> _games; 
  
  late final ValueNotifier<List<Game>> gamesState;

  late final ValueNotifier<List<Game>> suggestions;

/// ============================================================================================================== ///

  /// The current publisher filter active.
  final ValueNotifier<String?> publisherState = ValueNotifier(null);

  /// The current tags actived on the filter.
  final ValueNotifier<List<String>> tagsState = ValueNotifier(<String> []);

  /// Apply the currently active filters into the games list.
  /// 
  /// This function is used on the [Modals.filter] widget, when finishing the filter selection.
  void applyFilters() {
    gamesState.value = _games.where((element) {
      final bool matchesPublisher = publisherState.value == null ||  
                                    element.publisher == publisherState.value;

      final bool matchesTags = tagsState.value.isEmpty ||
                               tagsState.value.every((tag) => element.tags.contains(tag));

      return matchesPublisher && matchesTags;
    }).toList();
  }

  /// Clear the active filters.
  void clearFilters() {
    gamesState.value = _games;
    publisherState.value = null;
    tagsState.value.clear();
  }

/// ============================================================================================================= ///

  /// Filters the games list based on a search query.
  /// 
  /// The search is performed by checking if the query appears in any of the following fields:
  /// - If the game's title contains [query].
  /// - If the game's description contains [query].
  /// - If the game's year of release is equal to [query].
  /// - If the game's vendor contains [query].
  /// - If any tag matches the [query].
  void applySearch(String query) {
    query = query.toLowerCase();
  
    gamesState.value = _games.where((element) {
      final String title = element.title.toLowerCase();
      final String description = element.description!.toLowerCase();
      final String release = element.release.toString();
      final String vendor = element.publisher.toLowerCase();

      return title.contains(query) ||
             description.contains(query) ||
             release == query ||
             vendor.contains(query) ||
             element.tags.any((tag) => tag.toLowerCase() == query);
    }).toList();
  }

/// ============================================================================================================= ///

  Future<void> initialize() async {
    try {
      _games = database.games.all();

      gamesState = ValueNotifier(_games);
      suggestions = ValueNotifier(database.recents.all());
      progress.value = Progress.finished;
    }
    catch (error, stackTrace) {
      Logger.error.print(
        label: 'Search | Controller',
        message: '$error',
        stackTrace: stackTrace,
      );
      progress.value = Progress.error;
    }
  }

  /// Get a [Future] reference of a thumbnail from the [bucket].
  /// 
  /// This reference should be used on a [FutureBuilder].
  Future<File> getCover(String title) => bucket.cover(title);

  
}