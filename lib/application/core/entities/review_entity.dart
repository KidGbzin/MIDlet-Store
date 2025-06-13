import 'package:timeago/timeago.dart' as timeago;

import '../../../l10n/l10n_localizations.dart';

class Review {

  final String userKey;

  final String userName;

  final String comment;

  final String identifier;

  final String locale;
  
  final int rating;

  final String updatedAt;

  Review({
    required this.userKey,
    required this.comment,
    required this.identifier,
    required this.locale,
    required this.rating,
    required this.updatedAt,
    required this.userName,
  });

  Review.noReview() :
    userKey = "",
    comment = "",
    identifier = "",
    locale = "",
    rating = 0,
    updatedAt = "",
    userName = "";

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      "user_key": userKey,
      "comment": comment,
      "key": identifier,
      'locale': locale,
      'rating': rating,
      "updated_at": updatedAt,
      "user_name": userName,
    };
  }

  factory Review.fromJson(dynamic json) {
    return Review(
      userKey: json["user_key"] as String,
      comment: json["comment"] as String,
      identifier: json["key"] as String,
      locale: json['locale'] as String,
      rating: json['rating'] as int,
      updatedAt: json["updated_at"] as String,
      userName: json["user_name"] as String,
    );
  }

  String fRelativeDate(String locale) {
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