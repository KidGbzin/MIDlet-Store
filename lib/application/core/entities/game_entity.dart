import '../entities/midlet_entity.dart';

/// The entity resposible for the game information.
class Game {

  Game({
    required this.description,
    required this.main,
    required this.midlets,
    required this.release,
    required this.tags,
    required this.title,
    required this.publisher,
  });

  /// A brief piece of information about the game.
  final String? description;

  /// The main MIDlet file of the game, usually a K800i model version, represents the recommended version to play.
  final MIDlet main;

  /// A list of all [MIDlet] files available for this game.
  final List<MIDlet> midlets;

  /// The year the year when the game was released.
  final int release;

  /// A list of game caracteristcs such as Action, Shooter, Sports...
  final List<String> tags;

  /// Self-explanatory, just the game's title.
  final String title;

  /// Is the name of the company that released the game.
  final String publisher;

  /// Convert a JSON into a [Game] object.
  /// 
  /// The parameter [object] is the JSON dynamic object to be converted into a [Game].
  factory Game.fromJson(dynamic object) {
    return Game(
      description: object['description'] as String?,
      main: MIDlet.fromJson(object["main"]),
      midlets: List<MIDlet>.from(object["midlets"].map((element) => MIDlet.fromJson(element))),
      release: object['release'] as int,
      tags: List<String>.from(object["tags"].map((element) => element)),
      title: object['title'] as String,
      publisher: object['vendor'] as String,
    );
  }

  /// Export the [MIDlet] object to a JSON string.
  /// 
  /// This method is required to Hive write and read the object's data.
  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'description': description,
      'main': main.toJson(),
      'midlets': midlets.map((midlets) => midlets.toJson()).toList(),
      'release': release,
      'tags': tags,
      'title': title,
      'vendor': publisher,
    };
  }
}