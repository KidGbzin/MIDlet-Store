import 'package:flutter/foundation.dart';

/// Represents the currently active filters used on the [Search].
class ActiveFilters {

  /// List of active categories.
  final List<String> categories;

  /// Active publisher, or `null` if none.
  final String? publisher;

  /// The current active filtered year, or `null` if none.
  final int? year;

  const ActiveFilters({
    this.categories = const <String> [],
    this.publisher,
    this.year,
    UniqueKey? key,
  }) : assert(categories.length <= 3, 'You cannot select more than 3 categories filters!');

  ActiveFilters copyWith({
    List<String>? categories,
    String? publisher,
    int? year,
  }) {
    return ActiveFilters(
      categories: categories ?? this.categories,
      publisher: publisher ?? this.publisher,
      year: year ?? this.year,
      key: UniqueKey(),
    );
  }

  /// Checks if there are any active filters.
  bool hasAny() => categories.isNotEmpty || publisher != null || year != null;

  /// Checks if the given category is an active filter.
  bool hasCategory(String category) => categories.contains(category);

  /// Checks if the given publisher is an active filter.
  bool isPublisher(String publisher) => this.publisher == publisher;

  /// Checks if the given year is an active filter.
  bool isYear(int year) => this.year == year;
}
