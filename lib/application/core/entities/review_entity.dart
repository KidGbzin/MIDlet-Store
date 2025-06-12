class Review {

  final String author;

  final String? body;

  final int identifier;

  final String locale;
  
  final int rating;

  Review({
    required this.author,
    required this.body,
    required this.identifier,
    required this.locale,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'author': author,
      'body': body,
      'identifier': identifier,
      'locale': locale,
      'rating': rating,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      author: json['author'] as String,
      body: json['body'] as String?,
      identifier: json['identifier'] as int,
      locale: json['locale'] as String,
      rating: json['rating'] as int,
    );
  }
}