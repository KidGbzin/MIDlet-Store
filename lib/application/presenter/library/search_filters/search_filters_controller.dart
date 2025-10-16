part of '../search_filters/search_filters_handler.dart';

class _Controller implements IController {

  /// The list of games that will be iterated to count the occurrences of each filter.
  final List<Game> games;

  /// The localizations to get the localized names of the filters.
  final AppLocalizations l10n;

  /// The repository to get and generate filters.
  final FiltersRepository rFilters;

  /// The callback to apply the active filters.
  final Future<void> Function(ActiveFilters) onApply;

  _Controller({
    required this.games,
    required this.l10n,
    required this.rFilters,
    required this.onApply,
  });

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Notifiers ⮟

  /// The filters generated from the [games] and [l10n].
  late final Filters filters;

  @override
  void dispose() {
    nHandlerProgress.dispose();
  }
  
  @override
  Future<void> initialize() async {
    try {
      filters = rFilters.generate(games, l10n);
      
      nHandlerProgress.value = (
        state: Progresses.isReady,
        error: null,
      );
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );
    }
  }

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Notifiers ⮟

  final ValueNotifier<({Object? error, Progresses state})> nHandlerProgress = ValueNotifier((
    state: Progresses.isLoading,
    error: null,
  ));

  late final ValueNotifier<String?> nActivePublisher = ValueNotifier(rFilters.active.publisher);
  late final ValueNotifier<int?> nActiveYear = ValueNotifier(rFilters.active.year);
  late final ValueNotifier<List<String>> nActiveCategories = ValueNotifier(rFilters.active.categories);

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Filters ⮟

  /// Clear all the active filters, does not apply by default.
  void clear() {
    nActivePublisher.value = null;
    nActiveYear.value = null;
    nActiveCategories.value = <String> [];

    Logger.information('All filters have been cleared.');
  }

  /// Apply the active filters using the [onApply] callback.
  Future<void> apply() async {
    await onApply(ActiveFilters(
      publisher: nActivePublisher.value,
      year: nActiveYear.value,
      categories: nActiveCategories.value,
    ));
  }

  /// Change the active category filters.
  ///
  /// If the category is already active, it will be removed from the active filters.
  /// If the category is not active and the active filters count is less than 3, it will be added to the active filters.
  /// If the category is not active and the active filters count is 3, an information message will be logged.
  void onCategoryChange(String category) {
    final List<String> tCategories = List<String>.from(nActiveCategories.value);
  
    if (tCategories.contains(category)) {
      tCategories.remove(category);
    }
    else if (tCategories.length < 3) {
      tCategories.add(category);
    }
    else {
      Logger.information('You cannot select more than 3 categories filters!');
    }
  
    nActiveCategories.value = tCategories;
  
    Logger.information('Currently active categories: ${nActiveCategories.value}.');
  }

  /// Change the active publisher filter.
  ///
  /// If the publisher is already active, it will be removed from the active filters.
  /// If the publisher is not active, it will be added to the active filters.
  void onPublisherChange(String publisher) {
    if (nActivePublisher.value == publisher) {
      nActivePublisher.value = null;
    }
    else {
      nActivePublisher.value = publisher;
    }

    Logger.information('Currently active publisher: ${nActivePublisher.value}.');
  }

  /// Change the active year filter.
  ///
  /// If the year is already active, it will be removed from the active filters.
  /// If the year is not active, it will be added to the active filters.
  void onYearChange(int year) {
    if (nActiveYear.value == year) {
      nActiveYear.value = null;
    }
    else {
      nActiveYear.value = year;
    }

    Logger.information('Currently active year: ${nActiveYear.value}.');
  }
}
