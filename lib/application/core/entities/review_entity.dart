import 'package:timeago/timeago.dart' as timeago;

class Review {

  final String author;

  final String? body;

  final int identifier;

  final String locale;
  
  final int rating;

  final String updatedAt;

  Review({
    required this.author,
    required this.body,
    required this.identifier,
    required this.locale,
    required this.rating,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      "user_key": author,
      "review": body,
      "key": identifier,
      'locale': locale,
      'rating': rating,
      "updated_at": updatedAt,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      author: json["user_key"] as String,
      body: json["review"] as String?,
      identifier: json["key"] as int,
      locale: json['locale'] as String,
      rating: json['rating'] as int,
      updatedAt: json["updated_at"] as String,
    );
  }

  String fRelativeDate(String locale) {
    return timeago.format(
      DateTime.parse(updatedAt),
      locale: locale.split("_").first,
    );
  }
}