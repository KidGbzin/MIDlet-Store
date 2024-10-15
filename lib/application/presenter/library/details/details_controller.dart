part of 'details_handler.dart';

/// The controller used to handle the [Details] state and data.
class _Controller {

  _Controller({
    required this.bucket,
    required this.database,
  });

  /// The bucket service for fetching and storing data.
  late final IBucket bucket;

  /// The database service for data operations.
  late final IDatabase database;

  /// The game whose data is to be displayed.
  late final Game game;

  /// A listenable notifier for the favorite state.
  /// 
  /// Used in the [_Bookmark] component, it indicates whether the game is marked as a favorite.
  late final ValueNotifier<bool> isFavorite;

  /// The [progress] listenable.
  /// 
  /// Used in the [Details] handler, it represents the current state of the view when initialized.
  late final ValueNotifier<Progress> progress;
  
  /// Initializes the controller and fetches the necessary data using a game [title] as a key to display its data.
  /// 
  /// While the controller is fetching data, it updates the state of its [progress].
  Future<void> initialize(String title) async {
    progress = ValueNotifier(Progress.loading);
    try {
      game = database.games.fromTitle(title);
      isFavorite = ValueNotifier(database.favorites.contains(game));
      database.recents.put(game);
      progress.value = Progress.finished;
    }
    catch (error) {
      Logger.error.print(
        label: 'Details | Controller',
        message: '$error',
      );
      progress.value = Progress.error;
    }
  }

  /// Retrieves the main MIDlet from the [IBucket] and installs it.
  ///
  /// Exceptions to be handled:
  /// - `PlatformException`: Thrown by the [Activity] service, typically when no suitable activity is available.
  Future<void> installMIDlet(MIDlet midlet) async {

    /// Set a minimum load time for a better UX.
    List<dynamic> futures = await Future.wait([
      bucket.midlet(midlet),
      Future.delayed(Durations.extralong4),
    ]);

    final File file = futures.first;
    await Activity.emulator(file);
  }

  /// Opens the GitHub repository using the [Activity.gitHub] method.
  Future<void> openGitHub() async {
    try {
      await Activity.gitHub();
    }
    catch (error) {
      Logger.error.print(
        label: 'Details | Controller',
        message: '$error',
      );
    }
  }

  /// Opens the PlayStore emulator page using the [Activity.playStore] method.
  Future<void> openPlayStore() async {
    try {
      await Activity.playStore();
    }
    catch (error) {
      Logger.error.print(
        label: 'Details | Controller',
        message: '$error',
      );
    }
  }

  /// Retrieves a [Future] instance of [File] representing an audio file from the bucket.
  Future<File> get audio => bucket.audio(game.title);

  /// Retrieves a [Future] instance of [File] representing a thumbnail from the bucket.
  Future<File> get thumbnail => bucket.cover(game.title);

  /// Retrieves a [Future] instance of [List] containing [Uint8List] objects representing previews from the bucket.
  Future<List<Uint8List>> get previews => bucket.previews(game.title);

  /// Toggles the bookmark status of the current game.
  void toggleBookmarkStatus() {
    if (isFavorite.value) {
      database.favorites.delete(game);
    }
    else {
      database.favorites.put(game);
    }
    isFavorite.value = !isFavorite.value;
  }

  /// Discards the resources used by the controller.
  /// 
  /// This method should be called when the controller is no longer needed to free up resources.
  void dispose() {
    isFavorite.dispose();
    progress.dispose();
  }
}