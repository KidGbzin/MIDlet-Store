import 'dart:ui';

import 'package:midlet_store/application/core/entities/review_entity.dart';

import '../../logger.dart';

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
  
  Future<int> getOrInsertGameDownloads(Game game) async {
    final int response = await supabase.client.rpc(
      "get_or_insert_game_downloads",
      params: <String, dynamic> {
        "p_game_key": game.identifier,
      },
    );

    final String title = game.fTitle;

    Logger.success("Successfully fetched the downloads count for \"$title\" from Supabase: $response.");

    return response;
  }

  Future<Review?> getGameReviewFromUser(Game game) async {
    final List<dynamic> response = await supabase.client.rpc(
      "get_game_review_from_user",
      params: <String, dynamic> {
        "p_game_key": game.identifier,
      },
    );

    Logger.success("Successfully fetched the user review for \"${game.fTitle}\" from Supabase.");

    if (response.isEmpty) {
      return Review(
        author: supabase.client.auth.currentUser!.id,
        body: null,
        identifier: 0,
        locale: "",
        rating: 0,
      );
    }

    final Map<String, dynamic> row = response.first;

    return Review(
      author: supabase.client.auth.currentUser!.id,
      body: row["review"],
      identifier: row["key"],
      locale: row["locale"],
      rating: row["rating"],
    );
  }

  Future<int> getGameRatingsCount(Game game) async {
    final int response = await supabase.client.rpc(
      "count_ratings_for_game",
      params: <String, dynamic> {
        "p_game_key": game.identifier,
      },
    );

    final String title = game.title.replaceAll(' - ', ': ');
    Logger.success("Successfully fetched the total ratings for \"$title\" from Supabase: $response.");

    return response;
  }

  Future<double> getAverageRatingForGame(Game game) async {
    final double? response = await supabase.client.rpc(
      "get_average_rating_for_game",
      params: <String, dynamic> {
        "p_game_key": game.identifier,
      },
    );

    final String title = game.title.replaceAll(' - ', ': ');
    Logger.success("Successfully fetched the average rating for \"$title\" from Supabase: ${response ?? 0}.");

    return (response ?? 0.0).toDouble();
  }

  Future<Map<String, int>> getGameRatingsByStarsCount(Game game) async {
    final List<dynamic> response = await supabase.client.rpc(
      "count_ratings_by_star_for_game",
      params: <String, dynamic> {
        "p_game_key": game.identifier,
      },
    );

    final Map<String, int> ratings = <String, int> {};

    for (final Map<String, dynamic> row in response) {
      ratings[row['star']!.toString()] = row['count']!;
    }

    final String title = game.title.replaceAll(' - ', ': ');
    Logger.success(
      "Successfully fetched the ratings by stars for \"$title\" from Supabase: "
      "{5★: ${ratings["5"]}}, "
      "{4★: ${ratings["4"]}}, "
      "{3★: ${ratings["3"]}}, "
      "{2★: ${ratings["2"]}}, "
      "{1★: ${ratings["1"]}}.",
    );

    return ratings;
  }

  Future<void> upsertFirebaseToken(String token) async {
    await supabase.client.rpc(
      "upsert_fcm_token",
      params: <String, dynamic> {
        "p_token": token,
        "p_locale": PlatformDispatcher.instance.locale.toString(),
      },
    );

    Logger.success("Successfully registered the Firebase Cloud Messaging token on the Supabase.");
  }

  Future<Review> upsertGameReview(Game game, int rating, String review) async {
    await supabase.client.rpc(
      "upsert_game_rating",
      params: <String, dynamic> {
        "p_game_key": game.identifier,
        "p_rating": rating,
        "p_review": review,
        "p_locale": PlatformDispatcher.instance.locale.toString(),
      },
    );

    Logger.success("Successfully upserted the rating for \"${game.fTitle}\" on Supabase");

    return Review(
      author: supabase.client.auth.currentUser!.id,
      body: review,
      identifier: 0,
      locale: PlatformDispatcher.instance.locale.toString(),
      rating: rating,
    );
  }

  /// Increments the download count for the specified [Game].
  ///
  /// This method calls the Supabase RPC function `increment_game_downloads` to increment the download count.
  /// If the game doesn't exist in the metadata table, it will be inserted with an initial download count of 1.
  Future<void> incrementGameDownloads(Game game) async {
    await supabase.client.rpc(
      "increment_game_downloads",
      params: <String, dynamic> {
        "p_game_key": game.identifier,
      },
    );

    final String title = game.title.replaceAll(' - ', ': ');
    Logger.success('Successfully incremented the download count for "$title" on Supabase.');
  }
}