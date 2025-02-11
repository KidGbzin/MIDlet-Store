import '../core/entities/game_entity.dart';

import '../core/enumerations/logger_enumeration.dart';

import '../services/supabase_service.dart';

/// A repository class responsible for interacting with the Supabase database.
class SupabaseRepository {

  const SupabaseRepository(this.supabase);

  /// The service used for making requests to the database.
  final SupabaseService supabase;
  
  /// Fetches the average rating for a given [Game] from the database.
  /// 
  /// This method calls a remote function `average_rating_for_game` on the database and returns the average rating for the provided game.
  /// The average rating is rounded to the nearest whole number and returned as a [double].
  Future<double> getAverageRatingByGame(Game game) async {
    final num? response = await supabase.client.rpc(
      'average_rating_by_game',
      params: <String, dynamic> {
        'game_id_input': game.identifier,
      },
    );

    final String title = game.title.replaceAll(' - ', ': ');
    Logger.information.print(
      message: "\"$title\" average rating: ${response ?? 0}.", 
      label: "Database | GET • Average Rating",
    );

    return (response ?? 0).roundToDouble();
  }

  /// Fetches the rating distribution by star count for a given [Game].
  /// 
  /// This method calls a remote function `count_ratings_by_star` to get the count of ratings for each star value (1 to 5 stars) for the provided game.
  /// The response is a [Map] where the keys are strings representing the star values (e.g. "5", "4", etc.) and the values are the counts of ratings for each star value.
  Future<Map<String, int>> getGameRatingsByStarsCount(Game game) async {
    final List<dynamic> response = await supabase.client.rpc(
      'game_ratings_by_star_count',
      params: <String, dynamic> {
        'game_id_input': game.identifier,
      },
    );

    final Map<String, int> ratings = <String, int>{};

    for (Map<String, dynamic> row in response) {
      ratings[row['star']!.toString()] = row['count']!;
    }

    final String title = game.title.replaceAll(' - ', ': ');
    Logger.information.print(
      message: "\"$title\" ratings by star: "
               "{5★: ${ratings["5"]}}, "
               "{4★: ${ratings["4"]}}, "
               "{3★: ${ratings["3"]}}, "
               "{2★: ${ratings["2"]}}, "
               "{1★: ${ratings["1"]}}.", 
      label: "Database | GET • Ratings by Star Count",
    );

    return ratings;
  }

  /// Fetches the total number of ratings for a given [Game].
  /// 
  /// This method calls a remote function `count_total_ratings` to get the total count of ratings for the provided game.
  /// The response is a single [int] representing the total number of ratings for the game.
  Future<int> getGameRatingsCount(Game game) async {
    final int response = await supabase.client.rpc(
      'game_ratings_count',
      params: <String, dynamic> {
        'game_id_input': game.identifier,
      },
    );

    final String title = game.title.replaceAll(' - ', ': ');
    Logger.information.print(
      message: "\"$title\" total ratings: $response.", 
      label: "Database | GET • Ratings Count",
    );

    return response;
  }

  /// Fetches the current user's rating for a given [Game].
  /// 
  /// This method calls a remote function `get_user_rating_for_game` to fetch the user's rating for the provided game.
  /// The response is an [int] representing the user's rating for the game, or `0` if the user has not rated the game.
  Future<int> getUserRatingForGame(Game game) async {
    final int? response = await supabase.client.rpc(
      'user_rating_for_game',
      params: <String, dynamic> {
        'user_id_input': supabase.currentUserID,
        'game_id_input': game.identifier,
      },
    );

    final String title = game.title.replaceAll(' - ', ': ');
    Logger.information.print(
      message: "\"$title\" user rating: ${response ?? 0}.", 
      label: "Database | GET • User Rating for Game",
    );

    return response ?? 0;
  }
  
  /// Inserts or updates the user's rating for a given [Game].
  /// 
  /// This method calls a remote function `upsert_user_rating` to either insert or update the user's rating for the specified game.
  /// The response is a [Future] of [void].
  Future<void> upsertGameRating(Game game, int rating) async {
    await supabase.client.rpc(
      'upsert_game_rating',
      params: <String, dynamic> {
        'user_id_input': supabase.currentUserID,
        'game_id_input': game.identifier,
        'rating_input': rating,
      },
    );

    final String title = game.title.replaceAll(' - ', ': ');
    Logger.information.print(
      message: "\"$title\" rated by the user: $rating★.", 
      label: "Database | UPSERT • User Rating",
    );
  }

  /// Fetches the total number of downloads for a given [Game] and inserts a value if it does not exist.
  /// 
  /// This method calls a remote function `get_or_insert_downloads_count` to get the total count of downloads for the provided game.
  /// The response is a single [int] representing the total number of downloads for the game.
  /// If the value does not exist, it is inserted with a value of 0.
  Future<int> getOrInsertGameDownloads(Game game) async {
    final int response = await supabase.client.rpc(
      'get_or_insert_downloads_count',
      params: <String, dynamic> {
        'game_id_input': game.identifier,
      },
    );

    final String title = game.title.replaceAll(' - ', ': ');
    Logger.information.print(
      message: "\"$title\" downloads: $response.", 
      label: "Database | GET • Downloads Count",
    );

    return response;
  }
}
