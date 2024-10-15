part of 'home_handler.dart';

class _Controller {

  _Controller({
    required this.bucket,
    required this.database,
  });

  /// The bucket service for fetching and storing data.
  late final IBucket bucket;

  /// The database service for data operations.
  late final IDatabase database;

  /// Retrieves a [Future] instance of [File] representing a thumbnail from the bucket.
  Future<File> thumbnail(String title) => bucket.cover(title);

  List<Game> getGamesFromCategory(String tag) {
    List<Game> games = database.games.fromTags(<String> [tag]);
    games.shuffle();
    return games;
  }

  /// Get a list of random tags.
  /// 
  /// These random tags is used on the [Home] view to show random games to the user.
  List<Tag> getRandomTags(int length) {
    assert(length > 0);
    final List<Tag> temporary = <Tag> [];
    const List<Tag> tags = Tag.values;
    while(temporary.length < length) {
      final int index = Random().nextInt(tags.length - 1);
      if (!temporary.contains(tags[index])) {
        temporary.add(tags[index]);
      }
    }
    return temporary;
  }
}