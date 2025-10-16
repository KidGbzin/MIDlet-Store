part of 'search_handler.dart';

class _SearchView extends StatefulWidget {

  /// Manages all handler.cSearch instances for the Search view.
  final _Controller cHandler;

  const _SearchView(this.cHandler);

  @override
  State<_SearchView> createState() => _SearchState();
}

class _SearchState extends State<_SearchView> {
  late final AppLocalizations l10n = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget> [
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              onTap: () => context.pop(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: _SearchBar(widget.cHandler),
              ),
            ),
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedFilter,
              onTap: () => context.gtSearchFilters(
                activeFilters: widget.cHandler.activeFilters,
                games: widget.cHandler.allGames,
                onApply: widget.cHandler.onFiltersApply,
              ),
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: widget.cHandler.nListState,
        builder: (BuildContext context, ({Progresses state, Object? error}) progress, Widget? _) {
          Widget child = const SizedBox.shrink();

          if (progress.state == Progresses.isLoading) child = onLoading();
          if (progress.state == Progresses.isReady) child = onReady();
          
          return child;
        }
      ),        
    );
  }

  Widget onLoading() => LoadingAnimation();

  Widget onReady() {
    return ValueListenableBuilder(
      valueListenable: widget.cHandler.nGames,
      builder: (BuildContext context, List<Game> games, Widget? _) {
        return _ListView(
          controller: widget.cHandler,
          games: games,
        );
      }
    );
  }
}