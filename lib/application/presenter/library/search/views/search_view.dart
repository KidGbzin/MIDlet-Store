part of '../search_handler.dart';

class _SearchView extends StatefulWidget {

  const _SearchView({
    required this.controller,
  });

  final _Controller controller;

  @override
  State<_SearchView> createState() => _SearchState();
}

class _SearchState extends State<_SearchView> {
  late ScaffoldMessengerState snackbar;

  late final AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;
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
                child: _SearchBar(
                  controller: widget.controller,
                ),
              ),
            ),
            SizedBox.square(
              dimension: 40,
              child: ValueListenableBuilder(
                valueListenable: widget.controller.gameListState,
                builder: (BuildContext context, List<Game> games, Widget? _) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Text(
                        games.length.toString(),
                        style: TypographyEnumeration.body(ColorEnumeration.elements).style,
                      ),
                    ],
                  );
                },
              ),
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
              children: <Widget> [
                ValueListenableBuilder(
                  valueListenable: widget.controller.selectedTagsState,
                  builder: (BuildContext context, List<String> selectedTags, Widget? _) {
                    return _FilterButton(
                      color: selectedTags.isEmpty ? ColorEnumeration.foreground.value : ColorEnumeration.primary.value.withAlpha(190),
                      icon: HugeIcons.strokeRoundedArrowDown01,
                      title: localizations.chipFilterByCategories,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return _CategoriesModal(
                              controller: widget.controller,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: widget.controller.selectedPublisherState,
                  builder: (BuildContext context, String? selectedPublisher, Widget? _) {
                    return _FilterButton(
                      color: selectedPublisher == null ? ColorEnumeration.foreground.value : ColorEnumeration.primary.value.withAlpha(190),
                      icon: HugeIcons.strokeRoundedArrowDown01,
                      title: localizations.chipFilterByPublisher,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return _PublisherModal(
                              controller: widget.controller,
                            );
                          },
                        );
                      },
                    );
                  },   
                ),
                ValueListenableBuilder(
                  valueListenable: widget.controller.selectedReleaseYearState,
                  builder: (BuildContext context, int? selectedReleaseYear, Widget? _) {
                    return _FilterButton(
                      color: selectedReleaseYear == null ? ColorEnumeration.foreground.value : ColorEnumeration.primary.value.withAlpha(190),
                      icon: HugeIcons.strokeRoundedArrowDown01,
                      title: localizations.chipFilterByReleaseYear,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return _ReleaseModal(
                              controller: widget.controller,
                            );
                          },
                        );
                      },
                    );
                  },   
                ),
              ],
            ),
          ),
          Divider(
            color: ColorEnumeration.divider.value,
            height: 1,
            thickness: 1,
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: widget.controller.gameListState,
              builder: (BuildContext context, List<Game> currentlyActiveGameList, Widget? _) {
                return _ListView(
                  controller: widget.controller,
                  games: currentlyActiveGameList,
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}