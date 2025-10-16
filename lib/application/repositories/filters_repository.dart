import '../../l10n/l10n_localizations.dart';

import '../../logger.dart';
import '../core/entities/active_filters_entity.dart';
import '../core/entities/filters_entity.dart';
import '../core/entities/game_entity.dart';
import '../core/enumerations/tag_enumeration.dart';

class FiltersRepository {
  
  /// The currently active filters for the list of games.
  ActiveFilters active;

  FiltersRepository(this.active);

  /// Generates the filters for the given list of games.
  Filters generate(List<Game> games, AppLocalizations l10n) {
    final Map<String, int> tCategories = <String, int> {};
    final Map<String, int> tPublishers = <String, int> {};
    final Map<int, int> tYears = <int, int> {};
    
    // Iterate through the collection, counting the occurrences of each filter.
    // This loop was refactored to reduce the number of iterations that was used to retrieve the filters.
    for (final Game game in games) {
      final String publisher = game.publisher;
      final List<String> tags = game.tags;
      final int year = game.release;
  
      // Count the occurrences of games by year.
      tYears.update(
        year, (int v) => v + 1,
        ifAbsent: () => 1,
      );
  
      // Count the occurrences of games by publisher.
      tPublishers.update(
        publisher, (int v) => v + 1,
        ifAbsent: () => 1,
      );

      // Count the occurrences of games by tag.
      for (final tag in tags) {
        tCategories.update(
          tag, (int v) => v + 1,
          ifAbsent: () => 1,
        );
      }
    }

    final List<({Category category, int count, String name})> categories = [];
    final List<({int count, String publisher})> publishers = [];
    final List<({int count, int year})> years = [];

    categories.addAll(
      tCategories.entries.where((entry) {
        final Category category = Category.fromCode(entry.key);

        if (category == Category.error) Logger.warning("Category ${entry.key} has not been translated, ignoring it...");

        return category != Category.error;
      }).map((entry) {
        final Category category = Category.fromCode(entry.key);
    
        return (
          category: category,
          name: category.fromLocale(l10n),
          count: entry.value,
        );
      }),
    );

    publishers.addAll(
      tPublishers.entries.map((entry) {
        return (
          count: entry.value,
          publisher: entry.key,
        );
      }),
    );

    years.addAll(
      tYears.entries.map((entry) {
        return (
          count: entry.value,
          year: entry.key,
        );
      }),
    );

    categories.sort((a, b) => a.name.compareTo(b.name));
    publishers.sort((a, b) => b.count.compareTo(a.count));
    years.sort((a, b) => a.year.compareTo(b.year));

    return Filters(
      categories: categories,
      publishers: publishers,
      years: years,
    );
  }
}