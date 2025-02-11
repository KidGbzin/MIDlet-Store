/// A class representing a game data cache from the database, used to economize requests.
/// 
/// This class holds details about a game, such as the average rating, the user's rating, a star rating distribution, and the total number of ratings.
/// It is used to cache game data locally, reducing the need for frequent server requests.
class GameData {

  GameData({
    this.averageRating,
    this.downloads,
    required this.identifier,
    this.myRating,
    this.stars,
    this.totalRatings,
  });

  /// The average rating of the game.
  /// 
  /// This is the aggregated rating from all users.
  double? averageRating;

  /// The total number of downloads.
  ///
  /// Represents the number of times the game or content has been downloaded.
  int? downloads;

  /// A unique identifier for the game.
  final int identifier;

  /// The rating given by the current user.
  int? myRating;

  /// A map representing the distribution of star ratings.
  /// 
  /// The key is the star count, and the value is how many users gave that star count.
  Map<String, int>? stars;

  /// The total number of ratings the game has received.
  int? totalRatings;
  
  /// Creates a [GameData] instance from a JSON object.
  ///
  /// This method is used to parse data received from a JSON object and convert it into an instance of [GameData].
  factory GameData.fromJson(dynamic object) {
    return GameData(
      averageRating: object['averageRating'],
      downloads: object['downloads'],
      identifier: object['identifier'],
      totalRatings: object['totalRatings'],
      myRating: object['myRating'],
      stars: object['stars'] != null ? Map<String, int>.from(object['stars']) : null,
    );
  }

  /// Converts the [GameData] instance into a JSON object.
  ///
  /// This method is used in the Hive adapter to handle the [GameData] object, serializing it for storage or transmission.
  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'averageRating': averageRating,
      'downloads': downloads,
      'identifier': identifier,
      'myRating': myRating,
      'totalRatings': totalRatings,
      'stars': stars,
    };
  }
}