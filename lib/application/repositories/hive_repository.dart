import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../core/entities/game_data_entity.dart';
import '../core/entities/game_entity.dart';

import '../core/enumerations/logger_enumeration.dart';
import '../services/github_service.dart';

import '../interfaces/box_interface.dart';

// HIVE REPOSITORY 🧩: ========================================================================================================================================================== //

/// A class responsible for managing the cache of game data.
///
/// The [HiveRepository] class interacts with the local storage, initializing boxes for storing games, favorites, recent games, and cached requests using [Hive]. 
/// It also provides functionality to fetch and update game data from the API.
class HiveRepository {

  HiveRepository(this.sGitHub);

  /// An instance of [GitHubService] service used to fetch game data from the API.
  final GitHubService sGitHub;

  /// A box for managing cached requests.
  late final BoxCachedRequests boxCachedRequests;

  /// A box instance for managing the user's favorite games.
  late final BoxFavorites boxFavorites;

  /// A box instance for managing the collection of games.
  late final BoxGames boxGames;

  /// A box instance for managing the user's recent games.
  late final BoxRecentGames boxRecentGames;

  /// A box instance for managing the user's settings.
  late final BoxSettings boxSettings;

  /// Initializes the [HiveRepository] class, setting up the local storage directories and registering adapters for Hive boxes.
  ///
  /// It also clears all existing data and updates the local database with data from the API.
  Future<void> initialize() async {
    Logger.information.log("Initializing the Hive repository...");

    final Directory? directory = await getExternalStorageDirectory();

    Hive.defaultDirectory = directory!.path;

    Hive.registerAdapter('Game', Game.fromJson);
    Hive.registerAdapter('GameData', GameData.fromJson);

    boxCachedRequests = BoxCachedRequests(Hive.box<GameData>(
      maxSizeMiB: 1,
      name: 'CACHED_REQUESTS',
    ))..clear();

    boxGames = BoxGames(Hive.box<Game>(
      maxSizeMiB: 1,
      name: 'GAMES',
    ));

    boxFavorites = BoxFavorites(Hive.box<Game>(
      maxSizeMiB: 1,
      name: 'FAVORITES',
    ));

    boxRecentGames = BoxRecentGames(Hive.box<Game>(
      maxSizeMiB: 1,
      name: 'RECENT_GAMES',
    ));

    boxSettings = BoxSettings(Hive.box(
      maxSizeMiB: 1,
      name: 'SETTINGS',
    ));

    await _fetchStaticDatabase();
  }
  
  /// Fetches the game collection from the GitHub repository and updates the local database with it.
  ///
  /// The game collection is stored as a JSON file in the root directory of the GitHub repository.
  /// This file contains a list of games, which is parsed and saved to the local storage boxes. 
  /// Caching the collection locally helps reduce the number of API requests and conserve resources.
  ///
  /// Throws:
  /// - `Exception`: If the JSON file cannot be found or fetched.
  Future<void> _fetchStaticDatabase() async {
    const String source = "Database/DATABASE.json";

    DateTime? lastUpdated;
    DateTime? lastCached = boxSettings.lastUpdated;

    try {
      lastUpdated = await sGitHub.getLastUpdatedDate(source);
    }
    catch (error, stackTrace) {
      Logger.error.log(
        "$error",
        stackTrace: stackTrace,
      );

      rethrow;
    }
    
    if (lastCached != null && lastUpdated.isBefore(lastCached)) {
      Logger.information.log("The local database is already up-to-date, no update required.");

      return;
    }
    
    final Uint8List? bytes;

    try {
      bytes = await sGitHub.get(source);

      if (bytes == null) {
        throw Exception('The file "$source" could not be found in the repository.');
      }
    }
    catch (error, stackTrace) {
      Logger.error.log(
        "$error",
        stackTrace: stackTrace,
      );

      rethrow;
    }

    try {
      final List decoded = jsonDecode(utf8.decode(bytes));
      final List<Game> collection = decoded.map(Game.fromJson).toList();

      boxGames.clear();
      for (final Game game in collection) {
        boxGames.put(game);
      }

      boxSettings.setLastUpdated(DateTime.now().toString());

      Logger.success.log("The local database was updated successfully with ${collection.length} games.");
    }
    catch (error, stackTrace) {
      Logger.error.log(
        "$error",
        stackTrace: stackTrace,
      );

      throw Exception('Error parsing or storing the local database with Hive.');
    }
  }
}

// SETTINGS BOX 🧩: ============================================================================================================================================================= //

/// A storage box for caching settings data, specifically user preferences and configuration details.
/// 
/// This class implements [IBox] and provides functionality for managing cached settings, such as user locale and last updated timestamp.
/// The data is stored in a [Hive] box, allowing efficient storage and retrieval of settings-related values.
///
/// The class handles settings storage with a focus on localization and tracking the last time settings were updated.
/// The settings data is stored persistently, making it available across application sessions.
class BoxSettings implements IBox {

  const BoxSettings(this._box);

  /// The internal [Hive] box instance used for managing settings data.
  ///
  /// This field is private to ensure that the box's operations and lifecycle are controlled exclusively through this class.
  /// Preventing unintended modifications or access outside its intended scope.
  final Box _box;

  /// The key for storing and retrieving the last updated timestamp.
  ///
  /// This key holds the timestamp indicating the last time the settings were updated.
  final String _lastUpdated = "LAST_UPDATED";

  @override
  void clear() => _box.clear();

  @override
  void close() => _box.close();

  /// Retrieves the stored last updated timestamp as a [DateTime] object.
  /// 
  /// The timestamp represents the last time the settings were updated. If the timestamp cannot be parsed, it returns `null`.
  DateTime? get lastUpdated {
    final String? dateTime = _box.get(_lastUpdated);

    return DateTime.tryParse(dateTime ?? "");
  }

  /// Stores or updates the last updated timestamp in storage.
  /// 
  /// This function records the timestamp indicating when the settings were last updated.
  /// It is useful for tracking changes or synchronizing settings with remote data.
  void setLastUpdated(String lastUpdated) => _box.put(_lastUpdated, lastUpdated);
}

// CACHED REQUESTS BOX 🧩: ====================================================================================================================================================== //

/// A storage box for caching game request data retrieved from Supabase.
///
/// This class implements [IBox] and provides functionality for managing cached data, allowing efficient retrieval and storage of [GameData] objects.
/// The cached data is stored in a Hive box with a maximum size of 1 MiB.
class BoxCachedRequests implements IBox {

  const BoxCachedRequests(this._box);

  /// The internal [Hive] box instance used for managing [GameData].
  ///
  /// This field is private to ensure that the box's operations and lifecycle are controlled exclusively through this class.
  /// Preventing unintended modifications or access outside its intended scope.
  final Box<GameData> _box;
  
  @override
  void clear() => _box.clear();

  @override
  void close() => _box.close();

  /// Retrieves a [GameData] object from storage, using the provided key.
  ///
  /// Returns `null` if no data exists for the provided key.
  GameData? get(String key) =>_box.get(key);

  /// Puts or updates a [GameData] object in the storage box.
  void put(GameData gameData) => _box.put('${gameData.identifier}', gameData);
}

// FAVORITES BOX 🧩: ============================================================================================================================================================ //

/// A storage box for managing the user's favorite games.
///
/// This class implements [IBox] and provides functionality for adding, removing, and retrieving [Game] objects from a Hive box.
/// The box stores games based on their title and ensures that the operations are encapsulated to avoid direct manipulation outside this class.
class BoxFavorites implements IBox {

  const BoxFavorites(this._box);

  /// The internal [Hive] box instance used for managing [GameData].
  ///
  /// This field is private to ensure that the box's operations and lifecycle are controlled exclusively through this class.
  /// Preventing unintended modifications or access outside its intended scope.
  final Box<Game> _box;

  @override
  void close() => _box.close();

  @override
  void clear() => _box.clear();

  /// Checks if a [Game] is present in the favorites.
  bool contains(Game game) => _box.containsKey(game.title);

  /// Retrieves a [Game] from the favorites by its index.
  Game? fromIndex(int index) => _box[index];

  /// Gets the number of favorite games stored in the box.
  int get length => _box.length;

  /// Puts or updates a [Game] in the favorites.
  void put(Game game) => _box.put(game.title, game);

  /// Removes a [Game] from the favorites.
  void remove(Game game) => _box.delete(game.title);
}

// GAMES BOX 🧩: ================================================================================================================================================================ //

/// A storage box for managing [Game] objects retrieved and stored in Hive.
///
/// This class implements [IBox] and provides various methods for interacting with the stored [Game] objects.
/// It can retrieving games by index, title, publisher, or tags, and performing operations like adding, removing, and clearing games from the collection.
class BoxGames implements IBox {

  const BoxGames(this._box);

  /// The internal [Hive] box instance used for managing [GameData].
  ///
  /// This field is private to ensure that the box's operations and lifecycle are controlled exclusively through this class.
  /// Preventing unintended modifications or access outside its intended scope.
  final Box<Game> _box;

  /// Retrieves all [Game] objects stored in the box as a list.
  List<Game> all() {
    final List<Game> temporary = <Game> [];
    for (int index = 0; index < _box.length; index++) {
      temporary.add(_box[index]!);
    }
    return temporary;
  }

  @override
  void close() => _box.close();

  @override
  void clear() => _box.clear();

  /// Retrieves a [Game] from the storage box using its index.
  /// 
  /// Exceptions to be handled:
  /// - `Exception`: If the index is out of range.
  Game fromIndex(int index) {
    final Game? game = _box[index];
    if (game == null) {
      throw Exception('The index "$index" is out of range ${_box.length}!');
    }
    return game;
  }

  /// Retrieves a [Game] from the storage box by its title.
  /// 
  /// Throws:
  /// - `Exception`: If the game is not in the box.
  Game fromTitle(String title) {
    final Game? game = _box.get(title);
    if (game == null) {
      throw Exception('The game "$title" does not exist on the box!');
    }
    return game;
  }

  /// Retrieves a list of [Game] objects with the given publisher.
  List<Game> fromPublisher(String publisher) {
    final List<Game> temporary = <Game> [];
    for (int index = 0; index < _box.length; index++) {
      final Game game = _box[index]!;
      if (publisher == game.publisher) {
        temporary.add(game);
      }
    }
    return temporary;
  }

  /// Retrieves a list of [Game] objects that match the given tags.
  List<Game> fromTags(List<String> tags) {
    final List<Game> temporary = <Game> [];
    for (int index = 0; index < _box.length; index++) {
      final Game game = _box[index]!;
      if (tags.every((String tag) => game.tags.contains(tag))) {
        temporary.add(game);
      }
    }
    return temporary;
  }

  /// Gets the list of all keys of the stored [Game] objects.
  List<String> get keys => _box.keys;

  /// Gets the number of [Game] objects stored in the box.
  int get length => _box.length;
  
  /// Puts a new [Game] or updates an existing game in the storage box.
  void put(Game game) => _box.put(game.title, game);

  /// Retrieves the top related games based on the tags of a given game.
  ///
  /// This function extracts the tags of the provided game and uses them to find other games that are related based on shared tags.
  /// It offloads the computationally expensive task of ranking the related games to an isolate, retrieving the corresponding game objects from the local collection.
  Future<List<Game>> topRelatedGames(Game game) async {
    final List<Game> temporary = <Game> [];
    final List<String> tags = game.tags;

    final Map<String, List<String>> collection = _extractGameTags(game);

    final List<String> topRelatedGames = await compute(
      _isolateTopRelatedGames,
      <String, dynamic>{
        'tags': tags,
        'collection': collection,
      },
    );

    for (String element in topRelatedGames) {
      temporary.add(_box.get(element)!);
    }

    return temporary;
  }

  /// Extracts a map of game titles and their associated tags from a collection of games.
  ///
  /// This function iterates through a collection of games, excluding the current game, and returns a map of game titles and their associated tags.
  /// The function continues to loop through the collection until it reaches the end, where an exception is caught (indicating the collection has been fully traversed).
  Map<String, List<String>> _extractGameTags(Game actualGame) {
    final Map<String, List<String>> map = <String, List<String>> {};

    bool overflowed = false;
    int index = 0;

    while (!overflowed) {
      try {
        final Game game = _box[index]!;
        if (game.title != actualGame.title) map[game.title] = game.tags;
        index++;
      }
      catch (_) {
        overflowed = true;
      }
    }
    return map;
  }
}

/// Function that determines the top 8 most related games based on the provided tags.
///
/// This function takes a map containing tags and a collection of games with their associated tags.
/// It calculates the relevance of each game based on the provided tags, ranking the games and returning the top 8 most related ones.
/// The score of each game is based on the number of common tags with the provided tags, with a bonus point if the game has all the matching tags.
/// 
/// This function is designed to be used in an isolate due to its computationally intensive process, which is why it is implemented outside the main class.
List<String> _isolateTopRelatedGames(Map<String, dynamic> parameters) {
  final List<String> tags = parameters['tags'];
  final Map<String, List<String>> collection = parameters['collection'];

  final Map<String, int> ranking = Map.fromEntries(
    collection.entries.map((element) {
      final Set<String> tagsSet = element.value.toSet();

      int points = tags.where(tagsSet.contains).length;
      if (points == tagsSet.length) points++;

      return MapEntry(element.key, points);
    }),
  );

  final List<MapEntry<String, int>> sortedKeys = ranking.entries.toList()
    ..sort((x, y) => y.value.compareTo(x.value));

  final List<String> top8Keys = sortedKeys
    .where((entry) => entry.value > 0)
    .take(8)
    .map((entry) => entry.key)
    .toList();

  return top8Keys;
}

// RECENT GAMES BOX 🧩: ========================================================================================================================================================= //

/// A storage box for managing the most recent games played.
///
/// This class implements [IBox] and provides functionality for adding, removing, and retrieving [Game] objects from a Hive box.
/// The box ensures that only the most recent 10 games are stored, automatically deleting the oldest entry when a new game is added, maintaining a fixed size of 10 games.
class BoxRecentGames implements IBox {

  const BoxRecentGames(this._box);

  /// The internal [Hive] box instance used for managing [GameData].
  ///
  /// This field is private to ensure that the box's operations and lifecycle are controlled exclusively through this class.
  /// Preventing unintended modifications or access outside its intended scope.
  final Box<Game> _box;

  /// Retrieves all [Game] objects stored in the recent games list as a list.
  List<Game> all() {
    final List<Game> temporary = <Game> [];
    for (int index = 0; index < _box.length; index++) {
      temporary.add(_box[index]!);
    }
    return temporary;
  }

  @override
  void close() => _box.close();

  @override
  void clear() => _box.clear();

  /// Retrieves a [Game] from the recent games list by its index.
  Game? fromIndex(int index) => _box[index];

  /// Gets the number of recent games stored in the box.
  int get length => _box.length;

  /// Puts or updates a [Game] in the recent games list.
  ///
  /// If the game already exists, it will be deleted and added again at the most recent position.
  /// If the box reaches its limit of 10 games, the oldest game (at index 0) will be deleted to maintain the list size.
  void put(Game game) {
    if (_box.containsKey(game.title)) {
      _box.delete(game.title);
    }
    _box.put(game.title, game);
    if (_box.length == 10) {
      _box.deleteAt(0);
    }
  }
}