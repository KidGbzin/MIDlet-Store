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
  });

  Review.noReview() :
    userKey = "",
    userVote = 0,
    comment = "",
    gameKey = 0,
    identifier = "",
    locale = "",
    rating = 0,
    score = 0,
    updatedAt = "",
    nickname = "";

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      "user_key": userKey,
      "comment": comment,
      "game_key": gameKey,
      "key": identifier,
      'locale': locale,
      'rating': rating,
      'score': score,
      "updated_at": updatedAt,
      "nickname": nickname,
      "user_vote": userVote,
    };
  }

  factory Review.fromJson(dynamic jString) {
    return Review(
      comment: require<String>(jString, "comment")!,
      identifier: require<String>(jString, "key")!,
      gameKey: require<int>(jString, "game_key")!,
      locale: require<String>(jString, "locale")!,
      rating: require<int>(jString, "rating")!,
      score: require<int>(jString, "score")!,
      updatedAt: require<String>(jString, "updated_at")!,
      nickname: require<String>(jString, "nickname")!,
      userKey: require<String>(jString, "user_key")!,
      userVote: require<int>(jString, "user_vote")!,
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