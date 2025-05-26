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
  late final int? initialPublisher = widget.controller.nSelectedReleaseYear.value;
  late final AppLocalizations localizations = widget.localizations;

  @override
  void initState() {
    widget.controller.fetchFiltersReleaseYear();

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
            widget.controller.nSelectedReleaseYear.value = initialPublisher;
            context.pop();
          },
        ),
        ButtonWidget.icon(
          icon: HugeIcons.strokeRoundedTick02,
          onTap: () {
            widget.controller.applyFilters(context, localizations);
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
      description: localizations.sectionFilterReleaseYearDescription,
      title: localizations.sectionFilterReleaseYear,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: ValueListenableBuilder(
          valueListenable: widget.controller.nFiltersReleaseYear,
          builder: (BuildContext context, Map<int, int>? filters, Widget? _) {
            if (filters == null) {
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
              children: filters.entries.map(tile).toList(),
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
        widget.controller.nSelectedReleaseYear.value == releaseYear
          ? widget.controller.nSelectedReleaseYear.value = null
          : widget.controller.nSelectedReleaseYear.value = releaseYear;
      },
      child: ValueListenableBuilder(
        valueListenable: widget.controller.nSelectedReleaseYear,
        builder: (BuildContext context, int? selectedReleaseYear, Widget? _) {
          return Ink(
            decoration: BoxDecoration(
              borderRadius: gBorderRadius,
              color: selectedReleaseYear == releaseYear
                ? ColorEnumeration.primary.value.withAlpha(190)
                : ColorEnumeration.foreground.value,
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
                    style: TypographyEnumeration.rating(ColorEnumeration.grey).style,
                  ),
                ),
                Row(
                  spacing: 7.5,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Icon(
                      HugeIcons.strokeRoundedGameController03,
                      color: ColorEnumeration.grey.value,
                      size: 18,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "$count",
                        style: TypographyEnumeration.body(ColorEnumeration.grey).style,
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