import '../../core/entities/game_entity.dart';

import '../interfaces/database_interface.dart';

/// The games repository interface.
///
/// This interface is used by the [IDatabase] interface to manage the game library.
abstract class IGames {

  /// Retrieves all games in the collection.
  List<Game> all();

  /// Clears all games from the collection.
  void clear();

  /// Closes the connection to the games collection.
  void close();
  
  /// Retrieves a game by its index in the collection.
  Game fromIndex(int index);

  /// Retrieves a game by its title.
  Game fromTitle(String title);

  /// Retrieves games by its publisher.
  List<Game> fromPublisher(String publisher);

  /// Retrieves games by a category tags.
  List<Game> fromTags(List<String> tags);

  /// Gets the number of games in the collection.
  int get length;

  /// Gets a list of all game titles in the collection.
  List<String> get keys;

  /// Opens the connection to the games collection.
  void open();

  /// Adds a game to the collection.
  void put(Game game);
}