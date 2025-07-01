import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

import '../../logger.dart';

import '../core/entities/game_entity.dart';
import '../core/entities/game_metadata_entity.dart';
import '../interfaces/box_interface.dart';
import '../services/github_service.dart';

class SembastRepository {

  // MARK: Constructor ⮟

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
    final Database database = await databaseFactoryIo.openDatabase(join(directory.path, 'database.db'));

    boxCachedRequests = BoxCachedRequests(intMapStoreFactory.store('CACHED_REQUESTS'), database);
    boxGames = BoxGames(intMapStoreFactory.store('GAMES'), database);
    boxSettings = BoxSettings(stringMapStoreFactory.store('SETTINGS'), database);
    boxRecentGames = BoxRecentGames(intMapStoreFactory.store('RECENT_GAMES'), database);

    await _fetchStaticDatabase();
  }

  /// Fetches the game collection from the GitHub repository and updates the local database with it.
  ///
  /// The game collection is stored as a JSON file in the root directory of the GitHub repository.
  /// This file contains a list of games, which is parsed and saved to the local storage boxes. 
  /// Caching the collection locally helps reduce the number of API requests and conserve resources.
  ///
  /// Thrown:
  /// - `ClientException`: Thrown by the [http](https://pub.dev/packages/http) package, typically when there is no internet connection.
  /// - `FormatException`: Thrown by the GitHub repositorty or [Game] classes when parsing data fails (e.g., date formats or invalid JSON structure).
  /// - `HttpException`: Thrown when the GitHub repository file cannot be accessed or the server responds with an unexpected status code.
  Future<void> _fetchStaticDatabase() async {
    const String source = "Database/DATABASE.json";

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

/// A storage box for caching game request data retrieved from Supabase.
///
/// This class implements [IBox] and provides functionality for managing cached data, allowing efficient retrieval and storage of [GameMetadata] objects using Sembast.
/// The data is stored in a Sembast store with [String] keys and [Map<String, dynamic>] values.
class BoxCachedRequests implements IBox {

  final StoreRef<int, Map<String, dynamic>> store;

  final Database database;

  const BoxCachedRequests(this.store, this.database);

  @override
  Future<void> clear() => store.delete(database);

  @override
  Future<void> close() async {
    await database.close(); // optional — only if this box owns the db instance
  }

  /// Retrieves a [GameMetadata] object from storage, using the provided key.
  ///
  /// Returns `null` if no data exists for the provided key.
  Future<GameMetadata?> get(int key) async {
    try {
      final map = await store.record(key).get(database);
      return map == null ? null : GameMetadata.fromJson(map);
    } catch (error) {
      Logger.error("Cache read error: $error");
      return null;
    }
  }

  /// Puts or updates a [GameMetadata] object in the storage box.
  Future<void> put(GameMetadata metadata) async {
    await store.record(metadata.identifier).put(database, metadata.toJson());
  }
}

// MARK: Box Games ⮟

class BoxGames implements IBox {
  final StoreRef<int, Map<String, dynamic>> store;
  final Database db;

  const BoxGames(this.store, this.db);

  /// Retrieves all [Game] objects stored in the box as a list.
  Future<List<Game>> all() async {
    final records = await store.find(db);
    return records.map((r) => Game.fromJson(r.value)).toList();
  }

  @override
  Future<void> clear() => store.delete(db);

  @override
  Future<void> close() => db.close();

  /// Retrieves a [Game] from the storage box using its index.
  Future<Game> fromIndex(int index) async {
    final records = await store.find(db);
    if (index >= records.length) {
      throw Exception('The index "$index" is out of range ${records.length}!');
    }
    return Game.fromJson(records[index].value);
  }

  /// Retrieves a [Game] from the storage box by its identifier.
  Future<Game> fromId(int id) async {
    final map = await store.record(id).get(db);
    if (map == null) {
      throw Exception('The game with ID "$id" does not exist!');
    }
    return Game.fromJson(map);
  }

  /// Retrieves a list of [Game] objects with the given publisher.
  Future<List<Game>> fromPublisher(String publisher) async {
    final records = await store.find(db);
    return records
        .map((r) => Game.fromJson(r.value))
        .where((g) => g.publisher == publisher)
        .toList();
  }

  /// Retrieves a list of [Game] objects that match the given tags.
  Future<List<Game>> fromTags(List<String> tags) async {
    final records = await store.find(db);
    return records
        .map((r) => Game.fromJson(r.value))
        .where((g) => tags.every((tag) => g.tags.contains(tag)))
        .toList();
  }

  /// Gets the list of all keys (identifiers) of the stored [Game] objects.
  Future<List<int>> get keys async => store.findKeys(db);

  /// Gets the number of [Game] objects stored in the box.
  Future<int> get length async => store.count(db);

  /// Puts a new [Game] or updates an existing game in the storage box.
  Future<void> put(Game game) async {
    await store.record(game.identifier).put(db, game.toJson());
  }

  /// Retrieves the top related games based on the tags of a given game.
  Future<List<Game>> topRelatedGames(Game game) async {
    final allGames = await all();

    final Map<int, List<String>> collection = {
      for (final g in allGames)
        if (g.identifier != game.identifier) g.identifier: g.tags,
    };

    final List<int> relatedIds = await compute(
      _isolateTopRelatedGamesById,
      <String, dynamic>{
        'tags': game.tags,
        'collection': collection,
      },
    );

    final List<Game> related = [];
    for (final id in relatedIds) {
      final map = await store.record(id).get(db);
      if (map != null) related.add(Game.fromJson(map));
    }

    return related;
  }
}

/// Function that determines the top 8 most related games based on the provided tags.
///
/// This function takes a map containing tags and a collection of games with their associated tags.
/// It calculates the relevance of each game based on the provided tags, ranking the games and returning the top 8 most related ones.
/// The score of each game is based on the number of common tags with the provided tags, with a bonus point if the game has all the matching tags.
/// 
/// This function is designed to be used in an isolate due to its computationally intensive process, which is why it is implemented outside the main class.
List<int> _isolateTopRelatedGamesById(Map<String, dynamic> parameters) {
  final List<String> tags = parameters['tags'];
  final Map<int, List<String>> collection = parameters['collection'];

  final Map<int, int> ranking = Map.fromEntries(
    collection.entries.map((entry) {
      final tagsSet = entry.value.toSet();
      int score = tags.where(tagsSet.contains).length;
      if (score == tagsSet.length) score++;
      return MapEntry(entry.key, score);
    }),
  );

  final List<MapEntry<int, int>> sorted = ranking.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return sorted.where((e) => e.value > 0).take(8).map((e) => e.key).toList();
}



// MARK: Box Settings ⮟

class BoxSettings implements IBox {

  final StoreRef<String, dynamic> store;

  final Database database;

  BoxSettings(this.store, this.database);

  @override
  void clear() => store.delete(database);

  @override
  void close() {}

  Future<DateTime?> get lastUpdated async {
    final dynamic raw = await store.record('lastUpdated').get(database);
    return raw != null ? DateTime.tryParse(raw.toString()) : null;
  }

  Future<void> setLastUpdated() async {
    await store.record('lastUpdated').put(database, DateTime.now().toIso8601String());
  }
}

// MARK: -------------------------
// 
// 
// 
// MARK: Box Recent Games ⮟

/// A storage box for managing the most recent games played.
///
/// Stores the [identifier] as the key and a map containing only the [title] as the value.
/// Maintains a maximum of 10 recent games, replacing the oldest when adding new entries.
class BoxRecentGames implements IBox {
  final StoreRef<int, Map<String, dynamic>> store;
  final Database database;

  const BoxRecentGames(this.store, this.database);

  /// Retrieves all recent games as a list of (identifier, title).
  Future<List<(int id, String title)>> all() async {
    final records = await store.find(database);
    return records.map((r) => (r.key, r.value['title'] as String)).toList();
  }

  /// Gets the number of recent games stored.
  Future<int> get length async => store.count(database);

  /// Clears all recent game entries.
  @override
  Future<void> clear() => store.delete(database);

  /// Closes the database.
  @override
  Future<void> close() => database.close();

  /// Adds a recent game (or refreshes its order).
  Future<void> put(int identifier, String title) async {
    
    // Remove if already exists.
    await store.record(identifier).delete(database);

    final records = await store.find(database);
    if (records.length >= 10) {
      final oldest = records.first;
      await store.record(oldest.key).delete(database);
    }

    await store.record(identifier).put(database, {
      'title': title,
    });
  }
}