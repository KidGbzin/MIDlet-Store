import 'dart:ui';

import '../configuration/global_configuration.dart';

import '../entities/midlet_entity.dart';

/// Represents a game entity with its metadata and related MIDlets.
///
/// Stores localized descriptions, release info, tags, and publisher details.
class Game {

  // MARK: Constructor ⮟

  /// Game description in Brazilian Portuguese.
  final String descriptionBR;

  /// Game description in Indonesian.
  final String descriptionID;

  /// Game description in American English.
  final String descriptionUS;

  /// Unique identifier of the game (primary key).
  final int identifier;

  /// List of associated MIDlet files for this game.
  final List<MIDlet> midlets;

  /// Year the game was released.
  final int release;

  /// Tags categorizing the game (e.g., Action, Shooter).
  final List<String> tags;

  /// Game title.
  final String title;

  /// Publisher company name.
  final String publisher;

  final DateTime lastUpdated;

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
    required this.lastUpdated,
  });

  // MARK: Formats ⮟

  /// Returns the game description based on the [locale].
  /// 
  /// Throws:
  /// - `Exception`: If the locale is unsupported.
  String? fDescription(Locale locale) {
    switch (locale.countryCode) {
      case "BR": return descriptionBR;
      case "ID": return descriptionID;
      case "US": return descriptionUS;
      default: throw Exception("Unsupported locale: ${locale.languageCode} | ${locale.countryCode}.");
    }
  }

  /// Returns the formatted title, replacing " -" with ":" (e.g., "Bomberman - Deluxe" → "Bomberman: Deluxe").
  String get fTitle => title.replaceFirst(" -", ":");

  // MARK: JSON Methods ⮟

  /// Creates a [Game] instance from a JSON string.
  /// 
  /// The [jString] parameter is expected to be a dynamic object containing key-value pairs that map to the properties of this class.
  /// 
  /// Throws:
  /// - `FormatException`: Thrown when a required field is missing, null, or does not match the expected type during parsing.
  factory Game.fromJson(dynamic jString) {
    return Game(
      descriptionBR: require<String>(jString, "descriptionBR")!,
      descriptionID: require<String>(jString, "descriptionID")!,
      descriptionUS: require<String>(jString, "descriptionUS")!,
      identifier: require<int>(jString, "identifier")!,
      lastUpdated: require<DateTime>(
        jString,
        "updatedAt",
        convert: (lastUpdated) => DateTime.parse(lastUpdated),
      )!,
      midlets: require<List<MIDlet>>(
        jString,
        "midlets",
        convert: (midlets) => List<MIDlet>.from((midlets).map(MIDlet.fromJson)),
      )!,
      publisher: require<String>(jString, "publisher")!,
      release: require<int>(jString, "release")!,
      tags: require<List<String>>(
        jString,
        "tags",
        convert: (tags) => List<String>.from((tags).map((element) => element)),
      )!,
      title: require<String>(jString, "title")!,
    );
  }

  /// Converts this [Game] instance into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'descriptionBR': descriptionBR,
      'descriptionID': descriptionID,
      'descriptionUS': descriptionUS,
      'identifier': identifier,
      'updatedAt': lastUpdated.toIso8601String(),
      'midlets': midlets.map((midlets) => midlets.toJson()).toList(),
      'publisher': publisher,
      'release': release,
      'tags': tags,
      'title': title,
    };
  }
}