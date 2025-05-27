import 'dart:ui';

import 'package:midlet_store/logger.dart';

import '../core/entities/game_entity.dart';

import '../services/supabase_service.dart';

/// A repository class that handles interactions with the Supabase database.
///
/// This class offers high-level methods for performing operations such as inserting and updating records.
/// It serves as a centralized layer for all database access, abstracting the communication with Supabase tables and remote functions.
class SupabaseRepository {

  /// Manages Supabase authentication and database services, handling user sessions and data synchronization.
  final SupabaseService supabase;

  const SupabaseRepository(this.supabase);
  
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
    Logger.success("Successfully fetched the average rating for \"$title\" from Supabase: ${response ?? 0}.");

    final double value = (response ?? 0.0).toDouble();
    print(value);
    return value;
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
    Logger.success("Successfully fetched the ratings by stars for \"$title\" from Supabase: "
                       "{5★: ${ratings["5"]}}, "
                       "{4★: ${ratings["4"]}}, "
                       "{3★: ${ratings["3"]}}, "
                       "{2★: ${ratings["2"]}}, "
                       "{1★: ${ratings["1"]}}.",
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
    Logger.success("Successfully fetched the total ratings for \"$title\" from Supabase: $response.");

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
    Logger.success("Successfully fetched the user rating for \"$title\" from Supabase: ${response ?? 0}.");

    return response ?? 0;
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
    Logger.success("Successfully fetched the downloads count for \"$title\" from Supabase: $response.");

    return response;
  }
  
  /// Inserts or updates the user's rating for a given [Game].
  /// 
  /// This method calls a remote function `upsert_user_rating` to either insert or update the user's rating for the specified game.
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
    Logger.success("Successfully upserted the rating for \"$title\" on Supabase: $rating★.");
  }

  /// Inserts or updates the user's FCM token in the `fcm_tokens` table.
  ///
  /// This method ensures that the current device's FCM token is stored and associated with the authenticated user in Supabase.
  /// If the token already exists, the record is updated with the current locale and timestamp.
  Future<void> upsertFCMToken(String token, Locale locale) async {
    await supabase.client.from('fcm_tokens').upsert({
      'user_id': supabase.currentUserID,
      'token': token,
      'locale': "$locale",
      'last_seen': DateTime.now().toIso8601String(),
    },
      onConflict: 'token',
    );

    Logger.success("Successfully registered the FCM token.");
  }
}