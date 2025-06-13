import '../entities/review_entity.dart';

class GameMetadata {

  /// The average rating of the game.
  double? averageRating;

  /// The total number of downloads.
  int? downloads;

  /// A unique identifier for the game.
  final int identifier;

  /// The review given by the current user.
  Review? myReview;

  /// A map representing the distribution of star ratings.
  Map<String, int>? stars;

  /// The total number of ratings the game has received.
  int? totalRatings;
  
  GameMetadata({
    this.averageRating,
    this.downloads,
    required this.identifier,
    this.myReview,
    this.stars,
    this.totalRatings,
  });

  /// Creates a [GameMetadata] instance from a JSON object.
  factory GameMetadata.fromJson(dynamic json) {
    return GameMetadata(
      averageRating: json['Average-Rating'],
      downloads: json['Downloads'],
      identifier: json['Identifier'],
      myReview: json['My-Review'] != null ? Review.fromJson(json['My-Review']) : null,
      stars: json['Stars'] != null ? Map<String, int>.from(json['Stars']) : null,
      totalRatings: json['Total-Ratings'],
    );
  }

  /// Converts the [GameMetadata] instance into a JSON object.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Average-Rating': averageRating,
      'Downloads': downloads,
      'Identifier': identifier,
      'My-Review': myReview?.toJson(),
      'Stars': stars,
      'Total-Ratings': totalRatings,
    };
  }
}