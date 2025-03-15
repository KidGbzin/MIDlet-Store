import 'dart:ui';

import '../entities/midlet_entity.dart';

// GAME ENTITY 🎮: ============================================================================================================================================================== //

/// Entity representing a game's information.
///
/// This class stores essential details about a game, including its title, description, release year, tags, and publisher.
/// It is used both for displaying game data in the UI and for handling persistent storage.
class Game {

  Game({
    required this.descriptionBR,
    required this.descriptionID,
    required this.descriptionUS,
    required this.identifier,
    required this.midlets,
    required this.publisher,
    required this.release,
    required this.tags,
    required this.title,
  });

  /// The game description in Brazilian Portuguese.
  final String? descriptionBR;

  /// The game description in Indonesian.
  final String? descriptionID;

  /// The game description in American English.
  final String? descriptionUS;

  /// Unique identifier for the game.
  ///
  /// This ID serves as the primary key in the database.
  final int identifier;

  /// List of all [MIDlet] files available for this game.
  final List<MIDlet> midlets;

  /// The year the game was released.
  final int release;

  /// List of tags that categorize the game (e.g., Action, Shooter, Sports).
  final List<String> tags;

  /// The title of the game.
  final String title;

  /// The name of the company that published the game.
  final String publisher;

  /// Creates a [Game] object from a JSON map.
  ///
  /// This method is used to deserialize raw JSON data into a [Game] object.
  factory Game.fromJson(dynamic json) {
    return Game(
      descriptionBR: json['descriptionBR'] as String?,
      descriptionID: json['descriptionID'] as String?,
      descriptionUS: json['descriptionUS'] as String?,
      identifier: json['identifier'] as int,
      midlets: List<MIDlet>.from(json["midlets"].map((element) => MIDlet.fromJson(element))),
      publisher: json['publisher'] as String,
      release: json['release'] as int,
      tags: List<String>.from(json["tags"].map((element) => element)),
      title: json['title'] as String,
    );
  }

  /// Converts the [Game] object into a JSON map.
  ///
  /// This method is used for serializing the [Game] object, enabling it to be stored in databases like Hive.
  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'descriptionBR': descriptionBR,
      'descriptionID': descriptionID,
      'descriptionUS': descriptionUS,
      'identifier': identifier,
      'midlets': midlets.map((midlets) => midlets.toJson()).toList(),
      'publisher': publisher,
      'release': release,
      'tags': tags,
      'title': title,
    };
  }

  /// Retrieves the game description based on the given locale.
  /// 
  /// Throws:
  /// - `Exception`: If the locale is unsupported.
  String? description(Locale locale) {
    switch (locale.countryCode) {
      case "BR": return descriptionBR;
      case "ID": return descriptionID;
      case "US": return descriptionUS;
      default: throw Exception("Unsupported locale: ${locale.languageCode} | ${locale.countryCode}.");
    }
  }
}