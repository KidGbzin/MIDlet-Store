import 'package:hive/hive.dart';

import '../../core/entities/game_entity.dart';

import '../exceptions/games_exceptions.dart';

import '../interfaces/games_interface.dart';

class Games implements IGames {

  late final Box<Game> _box;

  @override
  Game fromIndex(int index) {
    final Game? game = _box[index];
  
    if (game == null) {
      throw GameException(
        message: 'The index "$index" is out of range ${_box.length}!',
      );
    }
  
    return game;
  }

  @override
  int get length => _box.length;

  @override
  List<String> get keys => _box.keys;

  @override
  Game fromTitle(String title) {
    final Game? game = _box.get(title);
    if (game == null) {
      throw GameException(
        message: 'The game "$title" does not exist on the box!',
      );
    }
    return game;
  }

  @override
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

  @override
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
  
  @override
  void close() => _box.close();
  
  @override
  void open() {
    _box = Hive.box<Game>(
      maxSizeMiB: 1,
      name: 'GAMES',
    );
  }

  @override
  void clear() => _box.clear();

  @override
  void put(Game game) => _box.put(game.title, game);

  @override
  List<Game> all() {
    final List<Game> temporary = <Game> [];
    for (int index = 0; index < _box.length; index++) {
      temporary.add(_box[index]!);
    }
    return temporary;
  }
}