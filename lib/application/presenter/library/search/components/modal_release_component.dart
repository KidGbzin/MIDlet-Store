part of '../search_handler.dart';

class _ReleaseModal extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _ReleaseModal(this.controller, this.localizations);

  @override
  State<_ReleaseModal> createState() => _ReleaseModalState();
}

class _ReleaseModalState extends State<_ReleaseModal> {
  late final int? initialYear = widget.controller.nSelectedFilters.value.year;
  late final AppLocalizations l10n = widget.localizations;

  @override
  void initState() {
    widget.controller.fetchFilters(l10n);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalWidget(
      actions: <Widget> [
        const Spacer(),
        ButtonWidget.icon(
          icon: HugeIcons.strokeRoundedCancel01,
          onTap: () {
            widget.controller.updateSelectedFilters(
              year: initialYear,
            );
            context.pop();
          },
        ),
        ButtonWidget.icon(
          icon: HugeIcons.strokeRoundedTick02,
          onTap: () {
            widget.controller.applyFilters(context, l10n);
            context.pop();
          },
        ),
      ],
      child: Expanded(
        child: SingleChildScrollView(
          child: body(),
        ),
      ),
    );
  }

  Widget body() {
    return Section(
      description: l10n.sectionFilterReleaseYearDescription,
      title: l10n.sectionFilterReleaseYear,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: ValueListenableBuilder(
          valueListenable: widget.controller.nFilters,
          builder: (BuildContext context, ({List<(TagEnumeration, String, int)> categories, Map<String, int> publishers, Map<int, int> years}) filters, Widget? _) {
            if (filters.years.isEmpty) {
              return Align(
                alignment: Alignment.center,
                child: LoadingAnimation(),
              );
            }
            return GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 7.5,
                crossAxisSpacing: 7.5,
                childAspectRatio: 1.25,
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: filters.years.entries.map(tile).toList(),
            );
          }
        ),
      ),
    );
  }

  Widget tile(MapEntry<int, int> entry) {
    final int releaseYear = entry.key;
    final int count = entry.value;
  
    return InkWell(
      borderRadius: gBorderRadius,
      onTap: () {
        if (widget.controller.nSelectedFilters.value.year == releaseYear) {
          widget.controller.updateSelectedFilters(
            year: null,
          );
        }
        else {
          widget.controller.updateSelectedFilters(
            year: releaseYear,
          );
        }
      },
      child: ValueListenableBuilder(
        valueListenable: widget.controller.nSelectedFilters,
        builder: (BuildContext context, ({List<String> categories, String? publisher, int? year})? filters, Widget? _) {
          return Ink(
            decoration: BoxDecoration(
              borderRadius: gBorderRadius,
              color: filters!.year == releaseYear
                ? Palettes.primary.value.withAlpha(190)
                : Palettes.foreground.value,
            ),
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 7.5,
              children: <Widget> [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "$releaseYear",
                    style: TypographyEnumeration.rating(Palettes.grey).style,
                  ),
                ),
                Row(
                  spacing: 7.5,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Icon(
                      HugeIcons.strokeRoundedGameController03,
                      color: Palettes.grey.value,
                      size: 18,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "$count",
                        style: TypographyEnumeration.body(Palettes.grey).style,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}