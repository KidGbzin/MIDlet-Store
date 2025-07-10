import 'dart:ui';

import '../../logger.dart';

import '../core/entities/game_entity.dart';
import '../core/entities/review_entity.dart';

import '../services/supabase_service.dart';

/// A repository class that handles interactions with the Supabase database.
///
/// This class offers high-level methods for performing operations such as inserting and updating records.
/// It serves as a centralized layer for all database access, abstracting the communication with Supabase tables and remote functions.
class SupabaseRepository {

  // MARK: Constructor ⮟

  /// Manages Supabase authentication and database services, handling user sessions and data synchronization.
  final SupabaseService supabase;

  const SupabaseRepository(this.supabase);

  // MARK: Counts ⮟

  /// Counts the number of ratings per star value (1 to 5) for the specified [Game].
  ///
  /// This function calls the Supabase stored procedure `count_ratings_by_star_for_game`, passing the game's unique identifier (`game.identifier`).
  /// It returns a map where the keys are the star values (`"1"` to `"5"`) and the values are the corresponding count of ratings.
  Future<Map<String, int>> countRatingsByStarForGame(Game game) async {
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

    Logger.success(
      "${game.fTitle} ratings: "
      "{5★: ${ratings["5"]}}, "
      "{4★: ${ratings["4"]}}, "
      "{3★: ${ratings["3"]}}, "
      "{2★: ${ratings["2"]}}, "
      "{1★: ${ratings["1"]}}.",
    );

    return ratings;
  }

  /// Retrieves the number of reviews for a given game from Supabase.
  ///
  /// This function calls the stored procedure `count_reviews_for_game` on Supabase, passing the game's unique identifier (`game.identifier`).
  /// It returns the total number of user-submitted reviews associated with the game.
  Future<int> countReviewsForGame(Game game) async {
    final int response = await supabase.client.rpc(
      "count_reviews_for_game",
      params: <String, dynamic> {
        "p_game_key": game.identifier,
      },
    );

    Logger.success("${game.fTitle} reviews count: $response.");

    return response;
  }

  // MARK: Increments ⮟

  /// Increments the download count for the specified [Game].
  ///
  /// This function calls the Supabase stored procedure `increment_downloads_for_game`, passing the game's unique identifier (`game.identifier`).
  /// If the game is not yet present in the metadata table, it will be inserted automatically with an initial download count of 1.
  Future<int> incrementDownloadsForGame(Game game) async {
    final int response = await supabase.client.rpc(
      "increment_downloads_for_game",
      params: <String, dynamic> {
        "p_game_key": game.identifier,
      },
    );

    Logger.success("${game.fTitle} downloads count +1.");

    return response;
  }

  // MARK: Gets ⮟

  /// Retrieves the average rating for a given game from Supabase.
  ///
  /// This function calls the stored procedure `get_average_rating_for_game` on Supabase, passing the game's unique identifier (`game.identifier`).
  /// The procedure returns the current average rating as a `double`.
  Future<double> getAverageRatingForGame(Game game) async {
    final double response = await supabase.client.rpc(
      "get_average_rating_for_game",
      params: <String, dynamic> {
        "p_game_key": game.identifier,
      },
    );

    Logger.success("${game.fTitle} average rating: ${response.toStringAsFixed(2)}.");

    return response;
  }

  /// Retrieves all user reviews for the specified [Game] from Supabase.
  ///
  /// This function calls the stored procedure `get_reviews_for_game`, passing the game's unique identifier (`game.identifier`).
  /// It returns a list of [Review] objects parsed from the response.
  Future<List<Review>> getReviewsForGame(Game game) async {
    final List<dynamic> response = await supabase.client.rpc(
      "get_reviews_for_game",
      params: <String, dynamic> {
        "p_game_key": game.identifier,
      }
    );

    Logger.success("${game.fTitle} total reviews: ${response.length}.");

    return response.map((review) => Review.fromJson(review as Map<String, dynamic>)).toList();
  }

  Future<List<Review>> getTop3ReviewsForGame(Game game) async {
    final List<dynamic> response = await supabase.client.rpc(
      "get_top_3_reviews_for_game",
      params: <String, dynamic> {
        "p_game_key": game.identifier,
      }
    );

    final List<Review> reviews = <Review> [];

    for (Map<String, dynamic> element in response) {
      reviews.add(Review.fromJson(element));
    }

    return reviews;
  }

  Future<List<({int identifier, double rating})>> getTop10RatedGames() async {
    final List<dynamic> response = await supabase.client.rpc(
      "get_top_rated_games_limited",
      params: <String, dynamic> {
        "p_elements": 10,
      }
    );

    final List<({int identifier, double rating})> results = <({int identifier, double rating})> [];

    for (Map<String, dynamic> element in response) {
      results.add((
        identifier: element["game_key"] as int,
        rating: element["average_rating"] as double,
      ));
    }

    return results;
  }

  /// Retrieves the current user's review for a given game from Supabase.
  ///
  /// This function calls the stored procedure `get_user_review_for_game`, passing the game's unique identifier (`game.identifier`).
  /// If a review exists, it returns a [Review] object parsed from the response.
  /// If no review is found, it returns a special [Review.notReviewed()] instance.
  Future<Review> getUserReviewForGame(Game game) async {
    final List<dynamic> response = await supabase.client.rpc(
      "get_user_review_for_game",
      params: <String, dynamic> {
        "p_game_key": game.identifier,
      },
    );

    if (response.isEmpty) {
      Logger.success("The user has not reviewed this game yet.");

      return Review.noReview();
    }

    final Review review = Review.fromJson(response.first);

    Logger.success("User review: ${review.rating}.");

    return review;
  }

  Future<(int, int)> getScoreForReview(Review review) async {
    final List<dynamic> response = await supabase.client.rpc(
      "get_score_for_review",
      params: <String, dynamic> {
        "p_review_key": review.identifier,
      },
    );

    final Map<String, dynamic> row = response.first;

    Logger.success("Review score: $row.");

    return (row["total_score"] as int, row["user_vote"] as int);
  }

  // MARK: Gets or Inserts ⮟
  
  /// Retrieves the downloads count for a given game from Supabase, inserting it if not present.
  ///
  /// This function calls the stored procedure `get_or_insert_downloads_for_game` on Supabase, passing the game's unique identifier (`game.identifier`).
  /// If the downloads record doesn't exist yet, the procedure will insert it and return the initial count of zero.
  Future<int> getOrInsertDownloadsForGame(Game game) async {
    final int response = await supabase.client.rpc(
      "get_or_insert_downloads_for_game",
      params: <String, dynamic> {
        "p_game_key": game.identifier,
      },
    );

    Logger.success("${game.fTitle} downloads count: $response.");

    return response;
  }

  // MARK: Upserts ⮟

  /// Registers or updates the Firebase Cloud Messaging (FCM) token in Supabase.
  ///
  /// This function calls the remote procedure `upsert_firebase_cloud_messaging_token` in Supabase, passing the FCM token and the device's current locale.
  /// This ensuresthe backend has the latest token to send push notifications to the user.
  Future<void> upsertFirebaseCloudMessagingToken(String token) async {
    await supabase.client.rpc(
      "upsert_firebase_cloud_messaging_token",
      params: <String, dynamic> {
        "p_token": token,
        "p_locale": PlatformDispatcher.instance.locale.toString(),
      },
    );

    Logger.success("Successfully registered the Firebase Cloud Messaging token on the Supabase.");
  }
  
  /// Inserts or updates the current user's review for the specified [Game].
  ///
  /// This function calls the Supabase stored procedure `upsert_rating_for_game`, providing the game's unique identifier (`game.identifier`),
  /// the new rating, an comment, and the user's current locale.
  ///
  /// If a rating already exists for the user and game, it will be updated.
  /// Otherwise, a new rating entry will be created.
  Future<Review> upsertReviewForGame(Game game, int rating, String comment) async {
    final List<dynamic> response = await supabase.client.rpc(
      "upsert_review_for_game",
      params: <String, dynamic> {
        "p_game_key": game.identifier,
        "p_rating": rating,
        "p_comment": comment,
        "p_locale": PlatformDispatcher.instance.locale.toString(),
      },
    );

    Logger.success("Upserted review!");

    return Review.fromJson(response.first);
  }

  Future<(int, int)> upsertVoteForReview(Review review, int vote) async {
    final List<dynamic> response = await supabase.client.rpc(
      "upsert_vote_for_review",
      params: <String, dynamic> {
        "p_review_key": review.identifier,
        "p_vote": vote,
      },
    );

    final Map<String, dynamic> row = response.first;

    Logger.success("Submited vote!: $vote.");

    return (row["total_score"] as int, row["user_vote"] as int);
  }
}