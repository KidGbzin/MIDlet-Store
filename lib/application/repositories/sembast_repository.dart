import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

import '../../logger.dart';

import '../core/entities/game_entity.dart';
import '../core/entities/game_metadata_entity.dart';

import '../services/github_service.dart';

/// A repository for managing structured data caching using Sembast.
///
/// Handles local persistence of game database, JSON objects, user settings, and API request results.
/// Integrates local storage with remote sources such as GitHub to efficiently cache and retrieve data when needed.
class SembastRepository {

  /// Handles interactions with the GitHub API, such as fetching remote files and checking for application updates.
  final GitHubService sGitHub;

  SembastRepository(this.sGitHub);

  /// A box for managing cached requests.
  late final BoxCachedRequests boxCachedRequests;

  /// A box instance for managing the collection of games.
  late final BoxGames boxGames;

  // /// A box instance for managing the user's recent games.
  late final BoxRecentGames boxRecentGames;

  /// A box instance for managing the user's settings.
  late final BoxSettings boxSettings;

  Future<void> initialize() async {
    Logger.start("Initializing the Sembast repository...");

    final Directory directory = await getApplicationCacheDirectory();
    final Database database = await databaseFactoryIo.openDatabase(join(directory.path, "database.db"));

    boxCachedRequests = BoxCachedRequests(intMapStoreFactory.store('CACHED_REQUESTS'), database);
    boxGames = BoxGames(intMapStoreFactory.store('GAMES'), database);
    boxSettings = BoxSettings(stringMapStoreFactory.store('SETTINGS'), database);
    boxRecentGames = BoxRecentGames(intMapStoreFactory.store('RECENT_GAMES'), database);

    await _fetchDatabase();
  }

  /// Fetches the game collection from the GitHub repository and updates the local database with it.
  ///
  /// The game collection is stored as a JSON file in the GitHub repository.
  /// This file contains a list of games, which is parsed and saved to the local storage boxes. 
  /// Caching the collection locally helps reduce the number of API requests and conserve resources.
  ///
  /// Thrown:
  /// - `ClientException`: If there is a network failure or no internet connection.
  /// - `FormatException`: If the JSON is malformed or the data cannot be parsed into [Game] objects.
  /// - `HttpException`: If the GitHub file cannot be accessed or returns an invalid status code.
  Future<void> _fetchDatabase() async {
    late final String? source;

    if (kDebugMode) source = "Database/DEBUG-DATABASE.json";

    source ??= "Database/DATABASE.json";

    DateTime? lastUpdated;
    DateTime? lastCached = await boxSettings.lastUpdated;

    lastUpdated = await sGitHub.getLastUpdatedDate(source);
    
    if (lastCached != null && lastUpdated.isBefore(lastCached)) {
      Logger.information("The local database is already up-to-date, no update required.");

      return;
    }
    
    final Uint8List? bytes = await sGitHub.get(source);

    final List<dynamic> decoded = jsonDecode(utf8.decode(bytes!));
    final List<Game> collection = decoded.map(Game.fromJson).toList();

    boxGames.clear();
    
    for (final Game game in collection) {
      boxGames.put(game);
    }
    boxSettings.setLastUpdated();
    
    Logger.success("The local database was updated successfully with ${collection.length} games.");
  }
}

// MARK: -------------------------
// 
// 
// 
// MARK: Box C. Requests ⮟

/// A storage box for caching [GameMetadata] objects retrieved from Supabase.
///
/// Provides efficient access and management of cached game metadata using Sembast.
/// The data is stored in a Sembast store with [int] keys and [Map<String, dynamic>] values.
class BoxCachedRequests {

  /// The Sembast store used to persist [GameMetadata] objects.
  final StoreRef<int, Map<String, dynamic>> store;

  /// The Sembast database instance associated with this box.
  final Database database;

  const BoxCachedRequests(this.store, this.database);

  /// Clears all stored [Game] objects from the box and returns a [Future] when complete.
  Future<void> clear() => store.delete(database);

  /// Retrieves a [GameMetadata] object from storage by the given key, or returns `null` if it does not exist.
  /// 
  /// Throws:
  /// - `FormatException`: If the JSON cannot be parsed into a valid [Game] using [Game.fromJson].
  Future<GameMetadata?> get(int key) async {
    try {
      final Map<String, dynamic>? record = await store.record(key).get(database);

      return record == null ? null : GameMetadata.fromJson(record);
    }
    catch (error, stackTrace) {
      Logger.error(
        "Cached request error: $error",
        stackTrace: stackTrace
      );

      return null;
    }
  }

  /// Puts or updates a [GameMetadata] object in the storage box.
  Future<void> put(GameMetadata metadata) async {
    await store.record(metadata.identifier).put(database, metadata.toJson());
  }
}

// MARK: -------------------------
// 
// 
// 
// MARK: Box Games ⮟

/// A storage box for managing the [Game] objects in the local database.
///
/// Provides functionality for managing [Game] objects, allowing efficient retrieval and storage of games using Sembast.
/// The data is stored in a Sembast store with [int] keys and [Map<String, dynamic>] values.
class BoxGames {

  /// The Sembast store used to persist [Game] objects.
  final StoreRef<int, Map<String, dynamic>> store;

  /// The Sembast database instance associated with this box.
  final Database database;

  const BoxGames(this.store, this.database);

  /// Retrieves all [Game] objects stored in the box as a list.
  /// 
  /// Throws:
  /// - `FormatException`: If the JSON cannot be parsed into a valid [Game] using [Game.fromJson].
  Future<List<Game>> all() async {
    final List<RecordSnapshot<int, Map<String, dynamic>>> records = await store.find(database);

    return records.map((r) => Game.fromJson(r.value)).toList();
  }

  /// Retrieves a list of [Game] objects that match the given categories.
  /// 
  /// Throws:
  /// - `FormatException`: If the JSON cannot be parsed into a valid [Game] using [Game.fromJson].
  Future<List<Game>> byCategories(List<String> tags) async {
    final List<RecordSnapshot<int, Map<String, dynamic>>> records = await store.find(database);

    return records
      .map((r) => Game.fromJson(r.value))
      .where((g) => tags.every((tag) => g.tags.contains(tag)))
      .toList();
  }

  /// Retrieves a [Game] from the storage box using its index.
  /// 
  /// Throws:
  /// - `FormatException`: If the JSON cannot be parsed into a valid [Game] using [Game.fromJson].
  /// - `RangeError`: If the index is out of bounds.
  Future<Game> byIndex(int index) async {
    final List<RecordSnapshot<int, Map<String, dynamic>>> records = await store.find(database);

    if (index >= records.length) throw RangeError.index(index, records, 'index');

    return Game.fromJson(records[index].value);
  }

  /// Retrieves a [Game] from the storage box by its identifier.
  /// 
  /// Throws:
  /// - `FormatException`: If the JSON cannot be parsed into a valid [Game] using [Game.fromJson].
  /// - `StateError`: If the game does not exist.
  Future<Game> byKey(int key) async {
    final Map<String, dynamic>? record = await store.record(key).get(database);

    if (record == null) throw StateError('The game with key "$key" does not exist!');

    return Game.fromJson(record);
  }

  /// Retrieves a list of [Game] objects with the given publisher.
  /// 
  /// Throws:
  /// - `FormatException`: If the JSON cannot be parsed into a valid [Game] using [Game.fromJson].
  Future<List<Game>> byPublisher(String publisher) async {
    final List<RecordSnapshot<int, Map<String, dynamic>>> records = await store.find(database);

    return records
      .map((r) => Game.fromJson(r.value))
      .where((g) => g.publisher == publisher)
      .toList();
  }

  /// Clears all stored [Game] objects from the box and returns a [Future] when complete.
  Future<void> clear() => store.delete(database);

  /// Retrieves the 10 most recently updated games, sorted by last updated in descending order.
  /// 
  /// Throws:
  /// - `FormatException`: If the JSON cannot be parsed into a valid [Game] using [Game.fromJson].
  Future<List<Game>> latest() async {
    final List<RecordSnapshot<int, Map<String, dynamic>>> records = await store.find(database);
    final List<Game> games = records.map((r) => Game.fromJson(r.value)).toList();

    games.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));

    return games.take(10).toList();
  }

  /// Gets the number of [Game] objects stored in the box.
  Future<int> get length async => store.count(database);

  /// Puts a new [Game] or updates an existing game in the storage box.
  /// 
  /// Throws:
  /// - `FormatException`: If the [Game] object cannot be serialized properly using [Game.toJson].
  Future<void> put(Game game) async {
    await store.record(game.identifier).put(database, game.toJson());
  }

  /// Retrieves the top related games based on the tags of a given game.
  /// 
  /// Throws:
  /// - `FormatException`: If the JSON cannot be parsed into a valid [Game] using [Game.fromJson].
  Future<List<Game>> related(Game game) async {
    final List<Game> games = await all();
    final Map<int, List<String>> collection = Map<int, List<String>>.fromEntries(
      games
        .where((g) => g.identifier != game.identifier)
        .map((g) => MapEntry(g.identifier, g.tags)),
    );

    final List<int> keys = await compute(
      _isolateRelatedGames,
      <String, dynamic> {
        'Categories': game.tags,
        'Collection': collection,
      },
    );

    final List<Game> related = <Game> [];

    for (final int key in keys) {
      final Map<String, dynamic>? record = await store.record(key).get(database);
      if (record != null) related.add(Game.fromJson(record));
    }

    return related;
  }
}

/// Function that determines the top 10 most related games based on the provided categories.
///
/// It calculates the relevance of each game based on the provided categories, ranking the games and returning the top 10 most related ones.
/// The score of each game is based on the number of common categories with the provided categories, with a bonus point if the game has all the matching tags.
/// 
/// This function is designed to be used in an isolate due to its computationally intensive process, which is why it is implemented outside the main class.
List<int> _isolateRelatedGames(Map<String, dynamic> parameters) {
  final List<String> categories = parameters['Categories'];
  final Map<int, List<String>> collection = parameters['Collection'];

  final Map<int, int> ranking = Map.fromEntries(
    collection.entries.map((entry) {
      final Set<String> set = entry.value.toSet();
      int score = categories.where(set.contains).length;

      if (score == set.length) score ++;

      return MapEntry(entry.key, score);
    }),
  );

  final List<MapEntry<int, int>> sorted = ranking.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return sorted.where((e) => e.value > 0).take(10).map((e) => e.key).toList();
}

// MARK: -------------------------
// 
// 
// 
// MARK: Box Settings ⮟

/// A storage box for managing app-level settings using Sembast.
///
/// The data is stored in a Sembast store with [String] keys and dynamic values.
class BoxSettings {

  /// The Sembast store used to persist settings.
  final StoreRef<String, dynamic> store;

  /// The Sembast database instance associated with this box.
  final Database database;

  BoxSettings(this.store, this.database);

  /// Clears all stored settings in the box.
  void clear() => store.delete(database);

  /// Gets the last update timestamp for the database stored in the box.
  Future<DateTime?> get lastUpdated async {
    final String? raw = await store.record('Last-Updated').get(database);

    return raw != null ? DateTime.tryParse(raw) : null;
  }

  /// Sets the current time as the last update timestamp in ISO 8601 format.
  Future<void> setLastUpdated() async {
    await store.record('Last-Updated').put(
      database,
      DateTime.now().toIso8601String(),
    );
  }
}

// MARK: -------------------------
// 
// 
// 
// MARK: Box Recent Games ⮟

/// A storage box for managing the user's recently accessed games.
///
/// Stores a maximum of 10 recent games, each identified by an [int] key and containing its title.
/// When a new game is added and the list is full, the oldest entry is removed.
class BoxRecentGames {

  /// The Sembast store used to persist recent game entries.
  final StoreRef<int, Map<String, dynamic>> store;

  /// The Sembast database instance associated with this box.
  final Database database;

  const BoxRecentGames(this.store, this.database);

  /// Retrieves all recent games as a list of tuples containing their identifier and title.
  Future<List<(int key, String title)>> all() async {
    final List<RecordSnapshot<int, Map<String, dynamic>>> records = await store.find(database);

    return records.map((r) => (r.key, r.value['Title'] as String)).toList();
  }

  /// Gets the number of recent games stored in the box.
  Future<int> get length async => store.count(database);

  /// Clears all recent game entries.
  Future<void> clear() => store.delete(database);

  /// Adds a game to the recent list, or refreshes its position if it already exists.
  ///
  /// If the list exceeds 10 items, the oldest entry is removed before adding the new one.
  Future<void> put(int identifier, String title) async {

    // Remove existing entry (if any) before adding the new one to ensure it is the most recent.
    await store.record(identifier).delete(database);

    // Ensure the limit of 10 recent items is not exceeded.
    final List<RecordSnapshot<int, Map<String, dynamic>>> records = await store.find(database);

    if (records.length >= 10) {
      final RecordSnapshot<int, Map<String, dynamic>> oldest = records.first;
      await store.record(oldest.key).delete(database);
    }

    await store.record(identifier).put(database, {
      'Title': title,
    });
  }
}