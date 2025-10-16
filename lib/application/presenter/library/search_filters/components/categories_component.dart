part of '../search_filters_handler.dart';

class _Categories extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller cHandler;

  const _Categories(this.cHandler);

  @override
  State<_Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<_Categories> {
  late final AppLocalizations l10n = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: <Widget> [
          Row(
            spacing: 7.5,
            children: <Widget> [
              Icon(
                HugeIcons.strokeRoundedLabelImportant,
                color: Palettes.elements.value,
                size: gIconSmall,
              ),
              Expanded(
                child: Text(
                  l10n.sectionFilterCategories,
                  style: TypographyEnumeration.headline(Palettes.elements).style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            l10n.sectionFilterCategoriesDescription,
            style: TypographyEnumeration.body(Palettes.grey).style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Wrap(
            runSpacing: 7.5,
            spacing: 7.5,
            children: widget.cHandler.filters.categories.map((record) {
              final bool isActive = widget.cHandler.rFilters.active.hasCategory(record.category.code);

              return chip(
                category: record.category,
                count: record.count,
                name: record.name,
                nIsActive: ValueNotifier<bool>(isActive),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget chip({
    required Category category,
    required int count,
    required ValueNotifier<bool> nIsActive,
    required String name,
  }) {
    return InkWell(
      borderRadius: gBorderRadius,
      onTap: () => widget.cHandler.onCategoryChange(category.code),
      child: ValueListenableBuilder(
        valueListenable: widget.cHandler.nActiveCategories,
        builder: (BuildContext context, List<String> activeCategories, Widget? _) {
          final bool isActive = activeCategories.contains(category.code);

          return FittedBox(
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: gBorderRadius,
                color: isActive
                  ? Palettes.primary.value.withAlpha(190)
                  : Palettes.foreground.value,
              ),
              height: 30,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                spacing: 7.5,
                children: <Widget> [
                  Icon(
                    category.icon,
                    color: Palettes.grey.value,
                    size: gIconSmall,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "$name • $count",
                      style: TypographyEnumeration.body(Palettes.grey).style,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
