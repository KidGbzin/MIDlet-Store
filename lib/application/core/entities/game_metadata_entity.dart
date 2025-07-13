import '../configuration/global_configuration.dart';

/// Represents aggregated metadata of a game, stored on the server.
///
/// This class models the dynamic metadata of a game, which is maintained and updated automatically by database triggers to improve performance and consistency.
/// For example, submitting a review will automatically update this metadata with the new Bayesian score, average rating, total number of reviews...
class GameMetadata {

  /// The average rating of the game.
  final num averageRating;

  /// The total number of downloads.
  final int downloads;

  /// A unique identifier for the game.
  final int identifier;

  /// Bayesian score of the game.
  final num score;

  /// The total number of ratings the game has received.
  final int totalReviews;
  
  const GameMetadata({
    required this.averageRating,
    required this.downloads,
    required this.identifier,
    required this.score,
    required this.totalReviews,
  });

  const GameMetadata.empty(int identifier) : this(
    averageRating: 0,
    downloads: 0,
    identifier: identifier,
    score: 0,
    totalReviews: 0,
  );

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Serialization ⮟

  /// Creates a [GameMetadata] instance from a JSON string.
  /// 
  /// The [jString] parameter is expected to be a dynamic object containing key-value pairs that map to the properties of this class.
  /// 
  /// Throws:
  /// - [FormatException]: If a required field is missing, null, or does not match the expected type during parsing.
  factory GameMetadata.fromJson(dynamic jString) {
    return GameMetadata(
      averageRating: require<double>(jString, 'Average-Rating')!,
      downloads: require<int>(jString, 'Downloads')!,
      identifier: require<int>(jString, 'Identifier')!,
      score: require<double>(jString, 'Score')!,
      totalReviews: require<int>(jString, 'Total-Ratings')!,
    );
  }

  /// Converts this [GameMetadata] instance into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'Average-Rating': averageRating,
      'Downloads': downloads,
      'Identifier': identifier,
      'Score': score,
      'Total-Ratings': totalReviews,
    };
  }
}