import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../l10n/l10n_localizations.dart';

import '../../../../logger.dart';

import '../../../core/configuration/global_configuration.dart';

import '../../../core/entities/active_filters_entity.dart';
import '../../../core/entities/filters_entity.dart';
import '../../../core/entities/game_entity.dart';

import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/progress_enumeration.dart';
import '../../../core/enumerations/tag_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../interfaces/controller_interface.dart';

import '../../../repositories/filters_repository.dart';

import '../../widgets/button_widget.dart';
import '../../widgets/handler_widget.dart';

part '../search_filters/components/categories_component.dart';
part '../search_filters/components/publisher_component.dart';
part '../search_filters/components/year_component.dart';

part '../search_filters/search_filters_controller.dart';
part '../search_filters/search_filters_view.dart';

class SearchFilters extends StatefulWidget {

  /// The currently active filters.
  final ActiveFilters activeFilters;

  /// The list of games to generate the filters.
  final List<Game> games;

  /// The localizations instance, used to retrieve localized strings.
  /// 
  /// Since the controller needs the l10n before the initialization, it is passed as a parameter.
  final AppLocalizations l10n;

  /// The function to be called when the filters are applied.
  final Future<void> Function(ActiveFilters) onApply;

  const SearchFilters({
    required this.activeFilters,
    required this.games,
    required this.onApply,
    required this.l10n,
    super.key,
  });

  @override
  State<SearchFilters> createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  late final _Controller cHandler;

  late final FiltersRepository rFilters;

  @override
  void initState() {
    super.initState();

    Logger.start("Initializing the Search filters handler...");

    rFilters = FiltersRepository(widget.activeFilters);

    cHandler = _Controller(
      rFilters: rFilters,
      games: widget.games,
      l10n: widget.l10n,
      onApply: widget.onApply,
    );
    
    cHandler.initialize();
  }

  @override
  void dispose() {
    cHandler.dispose();

    Logger.trash("Disposing the Search filters handler...");

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Handler(
      nProgress: cHandler.nHandlerProgress,
      onReady: _View(cHandler),
    );
  }
}
