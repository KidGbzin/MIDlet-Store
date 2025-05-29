part of '../search_handler.dart';

class _CategoriesModal extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _CategoriesModal(this.controller, this.localizations);

  @override
  State<_CategoriesModal> createState() => _CategoriesModalState();
}

class _CategoriesModalState extends State<_CategoriesModal> {
  late final List<String> initialTags = widget.controller.nSelectedTags.value;
  late final AppLocalizations localizations = widget.localizations;

  @override
  void initState() {
    widget.controller.fetchFiltersTags(localizations);

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
            widget.controller.nSelectedTags.value = initialTags;
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
      description: localizations.sectionFilterCategoriesDescription,
      title: localizations.sectionFilterCategories,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: ValueListenableBuilder(
          valueListenable: widget.controller.nFiltersTags,
          builder: (BuildContext context, List<(TagEnumeration, String, int)>? filters, Widget? _) {
            if (filters == null) {
              return Align(
                alignment: Alignment.center,
                child: LoadingAnimation(),
              );
            }
            return Wrap(
              runSpacing: 7.5,
              spacing: 7.5,
              children: filters.map(tile).toList(),
            );
          }
        ),
      ),
    );
  }

  Widget tile((TagEnumeration, String, int) record) {
    final TagEnumeration tag = record.$1;
    final String name = record.$2;
    final int count = record.$3;

    final ValueNotifier<bool> isSelected = ValueNotifier<bool>(widget.controller.nSelectedTags.value.contains(tag.code));

    return InkWell(
      borderRadius: gBorderRadius,
      onTap: () {
        final List<String> temporary = widget.controller.nSelectedTags.value;

        if (temporary.contains(tag.code)) {
          temporary.remove(tag.code);
          isSelected.value = !isSelected.value;
        }
        else if (temporary.length < 3) {
          temporary.add(tag.code);
          isSelected.value = !isSelected.value;
        }
        
        widget.controller.nSelectedTags.value = List.from(temporary);
      },
      child: ValueListenableBuilder(
        valueListenable: isSelected,
        builder: (BuildContext context, bool isSelected, Widget? _) {
          return FittedBox(
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: gBorderRadius,
                color: isSelected
                  ? Palettes.primary.value.withAlpha(190)
                  : Palettes.foreground.value,
              ),
              height: 30,
              padding: const EdgeInsets.fromLTRB(12.5, 0, 12.5, 0),
              child: Row(
                spacing: 7.5,
                children: <Widget> [
                  Icon(
                    tag.icon,
                    color: Palettes.grey.value,
                    size: 18,
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
        },
      ),
    );
  }
}