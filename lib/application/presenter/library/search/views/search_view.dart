part of '../search_handler.dart';

class _SearchView extends StatefulWidget {

  /// Manages all handler.cSearch instances for the Search view.
  final _Controller controller;

  const _SearchView(this.controller);

  @override
  State<_SearchView> createState() => _SearchState();
}

class _SearchState extends State<_SearchView> {
  late final AppLocalizations l10n;

  @override
  void didChangeDependencies() {
    l10n = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: Border(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget> [
            SizedBox.square(
              dimension: 40,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: _SearchBar(widget.controller),
              ),
            ),
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedArrowReloadHorizontal,
              onTap: () => widget.controller.clearFilters(),
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: widget.controller.nProgress,
        builder: (BuildContext context, (Progresses, Object?) progress, Widget? _) {
          if (progress.$1 == Progresses.isLoading) {
            return LoadingAnimation();
          }
          else if (progress.$1 == Progresses.isFinished) {
            return scaf(context);
          }
          else if (progress.$1 == Progresses.hasError) {
            return ErrorMessage(progress.$2!);
          }
          else {
            return ErrorMessage(Exception);
          }
        }          
      ),
    );
  }

  Widget scaf(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget> [
        Container(
          color: Palettes.background.value,
          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
          width: MediaQuery.sizeOf(context).width,
          child: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 7.5,
            runSpacing: 7.5,
            children: <Widget> [
              ValueListenableBuilder(
                valueListenable: widget.controller.nSelectedFilters,
                builder: (BuildContext context, ({List<String> categories, String? publisher, int? year})? filters, Widget? _) {
                  return _FilterButton(
                    color: filters!.categories.isEmpty ? Palettes.foreground.value : Palettes.primary.value.withAlpha(190),
                    icon: HugeIcons.strokeRoundedArrowDown01,
                    title: l10n.chipFilterByCategories,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => _CategoriesModal(widget.controller, l10n),
                      );
                    },
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: widget.controller.nSelectedFilters,
                builder: (BuildContext context, ({List<String> categories, String? publisher, int? year})? filters, Widget? _) {
                  return _FilterButton(
                    color: filters!.publisher == null ? Palettes.foreground.value : Palettes.primary.value.withAlpha(190),
                    icon: HugeIcons.strokeRoundedArrowDown01,
                    title: l10n.chipFilterByPublisher,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => _PublisherModal(widget.controller, l10n),
                      );
                    },
                  );
                },   
              ),
              ValueListenableBuilder(
                valueListenable: widget.controller.nSelectedFilters,
                builder: (BuildContext context, ({List<String> categories, String? publisher, int? year})? filters, Widget? _) {
                  return _FilterButton(
                    color: filters!.year == null ? Palettes.foreground.value : Palettes.primary.value.withAlpha(190),
                    icon: HugeIcons.strokeRoundedArrowDown01,
                    title: l10n.chipFilterByReleaseYear,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => _ReleaseModal(widget.controller, l10n),
                      );
                    },
                  );
                },   
              ),
            ],
          ),
        ),
        gDivider,
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: widget.controller.nGames,
            builder: (BuildContext context, List<Game> games, Widget? _) {
              return _ListView(
                controller: widget.controller,
                games: games,
              );
            }
          ),
        ),
      ],
  );
  }
}