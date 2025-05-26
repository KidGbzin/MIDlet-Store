part of '../search_handler.dart';

class _SearchView extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _SearchView(this.controller, this.localizations);

  @override
  State<_SearchView> createState() => _SearchState();
}

class _SearchState extends State<_SearchView> {
  late final AppLocalizations localizations = widget.localizations;

  late ScaffoldMessengerState snackbar;

  @override
  void didChangeDependencies() {
    snackbar = ScaffoldMessenger.of(context);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    snackbar.clearSnackBars();

    super.dispose();
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
              onTap: () => widget.controller.clearFilters(context, localizations),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget> [
          Container(
            color: ColorEnumeration.background.value,
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            width: MediaQuery.sizeOf(context).width,
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 7.5,
              runSpacing: 7.5,
              children: <Widget> [
                ValueListenableBuilder(
                  valueListenable: widget.controller.nSelectedTags,
                  builder: (BuildContext context, List<String> selectedTags, Widget? _) {
                    return _FilterButton(
                      color: selectedTags.isEmpty ? ColorEnumeration.foreground.value : ColorEnumeration.primary.value.withAlpha(190),
                      icon: HugeIcons.strokeRoundedArrowDown01,
                      title: localizations.chipFilterByCategories,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) => _CategoriesModal(widget.controller, localizations),
                        );
                      },
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: widget.controller.nSelectedPublisher,
                  builder: (BuildContext context, String? selectedPublisher, Widget? _) {
                    return _FilterButton(
                      color: selectedPublisher == null ? ColorEnumeration.foreground.value : ColorEnumeration.primary.value.withAlpha(190),
                      icon: HugeIcons.strokeRoundedArrowDown01,
                      title: localizations.chipFilterByPublisher,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) => _PublisherModal(widget.controller, localizations),
                        );
                      },
                    );
                  },   
                ),
                ValueListenableBuilder(
                  valueListenable: widget.controller.nSelectedReleaseYear,
                  builder: (BuildContext context, int? selectedReleaseYear, Widget? _) {
                    return _FilterButton(
                      color: selectedReleaseYear == null ? ColorEnumeration.foreground.value : ColorEnumeration.primary.value.withAlpha(190),
                      icon: HugeIcons.strokeRoundedArrowDown01,
                      title: localizations.chipFilterByReleaseYear,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) => _ReleaseModal(widget.controller, localizations),
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
              builder: (BuildContext context, (List<Game>, bool) listener, Widget? _) {
                if (listener.$2) {
                  return Align(
                    alignment: Alignment.center,
                    child: LoadingAnimation(),
                  );
                }
                else {
                  return _ListView(
                    controller: widget.controller,
                    games: listener.$1,
                  );
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}