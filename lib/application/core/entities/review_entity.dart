import 'dart:ui';

import 'package:timeago/timeago.dart' as timeago;

import '../../../l10n/l10n_localizations.dart';
import '../configuration/global_configuration.dart';

class Review {

  final String userKey;

  final String nickname;

  final String comment;

  final int gameKey;

  final String identifier;

  final String locale;

  final int score;
  
  final int rating;

  final String updatedAt;

  final int userVote;

  final int difficulty;

  final int playthroughTime;

  final int completionLevel;

  Review({
    required this.userKey,
    required this.comment,
    required this.gameKey,
    required this.identifier,
    required this.locale,
    required this.rating,
    required this.score,
    required this.updatedAt,
    required this.nickname,
    required this.userVote,
    required this.difficulty,
    required this.playthroughTime,
    required this.completionLevel,
  });

   Review copyWith({
    String? userKey,
    String? comment,
    int? gameKey,
    String? identifier,
    String? locale,
    int? rating,
    int? score,
    String? updatedAt,
    String? nickname,
    int? userVote,
    int? difficulty,
    int? timeSpent,
    int? completionLevel,
  }) {
    return Review(
      userKey: userKey ?? this.userKey,
      comment: comment ?? this.comment,
      gameKey: gameKey ?? this.gameKey,
      identifier: identifier ?? this.identifier,
      locale: locale ?? this.locale,
      rating: rating ?? this.rating,
      score: score ?? this.score,
      updatedAt: updatedAt ?? this.updatedAt,
      nickname: nickname ?? this.nickname,
      userVote: userVote ?? this.userVote,
      difficulty: difficulty ?? this.difficulty,
      playthroughTime: timeSpent ?? this.playthroughTime,
      completionLevel: completionLevel ?? this.completionLevel,
    );
  }

  Review.empty() :
    userKey = "",
    userVote = 0,
    comment = "",
    gameKey = 0,
    identifier = "",
    locale = "",
    rating = 0,
    score = 0,
    updatedAt = "",
    difficulty = 0,
    playthroughTime = 0,
    completionLevel = 0,
    nickname = "";

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      "r_user_key": userKey,
      "r_comment": comment,
      "r_game_key": gameKey,
      "r_key": identifier,
      'r_locale': locale,
      'r_rating': rating,
      'r_score': score,
      "r_updated_at": updatedAt,
      "r_nickname": nickname,
      "r_user_vote": userVote,
      "r_difficulty": difficulty,
      "r_completion_time": playthroughTime,
      "r_completion_level": completionLevel
    };
  }

  factory Review.fromJson(dynamic jString) {
    return Review(
      difficulty: require<int>(jString, "r_difficulty")!,
      playthroughTime: require<int>(jString, "r_completion_time")!,
      completionLevel: require<int>(jString, "r_completion_level")!,
      comment: require<String>(jString, "r_comment")!,
      identifier: require<String>(jString, "r_key")!,
      gameKey: require<int>(jString, "r_game_key")!,
      locale: require<String>(jString, "r_locale")!,
      rating: require<int>(jString, "r_rating")!,
      score: require<int>(jString, "r_score")!,
      updatedAt: require<String>(jString, "r_updated_at")!,
      nickname: require<String>(jString, "r_nickname")!,
      userKey: require<String>(jString, "r_user_key")!,
      userVote: require<int>(jString, "r_user_vote")!,
    );
  }

  String get fRelativeDate {
    final String locale = PlatformDispatcher.instance.locale.toString();

    return timeago.format(
      DateTime.parse(updatedAt),
      locale: locale.split("_").first,
    );
  }

  String get flag {
    final parts = locale.split('_');
    if (parts.length != 2) return '🌐';

    final String country = parts[1].toUpperCase();
    if (country.length != 2) return '🌐';

    return country
      .split('')
      .map((char) => String.fromCharCode(0x1F1E6 + char.codeUnitAt(0) - 'A'.codeUnitAt(0)))
      .join('');
  }

  String fBody(AppLocalizations localizations) {
    if (comment.isNotEmpty) return comment;

    switch (rating) {
      case 1: return localizations.txRating1Star;
      case 2: return localizations.txRating2Star;
      case 3: return localizations.txRating3Star;
      case 4: return localizations.txRating4Star;
      case 5: return localizations.txRating5Star;
      default: return "...";
    }
  }
}