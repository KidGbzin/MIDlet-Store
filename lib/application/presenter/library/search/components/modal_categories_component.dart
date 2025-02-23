part of '../search_handler.dart';

/// A modal widget that displays a list of categories to filter by.
///
/// This widget is composed of a list of tiles, each representing a category.
/// The selected categories are then used to filter the list of games.
///
/// The [controller] is responsible for managing the state of the search bar and the filters.
class _CategoriesModal extends StatefulWidget {

  const _CategoriesModal({
    required this.controller,
  });

  /// The controller that manages the state of the game list.
  /// 
  /// This controller is responsible for managing the state of the search bar and the filters.
  final _Controller controller;

  @override
  State<_CategoriesModal> createState() => _CategoriesModalState();
}

class _CategoriesModalState extends State<_CategoriesModal> {
  late final List<String> _initialState;
  late final AppLocalizations localizations;

  @override
  void initState() {
    _initialState = widget.controller.selectedTagsState.value;
    

    super.initState();
  }

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;
    

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return ModalWidget(
      actions: <Widget> [
        const Spacer(),
        ButtonWidget.icon(
          icon: HugeIcons.strokeRoundedCancel01,
          onTap: () {
            widget.controller.selectedTagsState.value = _initialState;
            context.pop();
          },
        ),
        ButtonWidget.icon(
          icon: HugeIcons.strokeRoundedTick02,
          onTap: () {
            widget.controller.applyFilters();
            context.pop();
          },
        ),
      ],
      child: SingleChildScrollView(
        child: Section(
          description: localizations.sectionFilterCategoriesDescription,
          title: localizations.sectionFilterCategories,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Wrap(
              runSpacing: 7.5,
              spacing: 7.5,
              children: widget.controller.getCategories(localizations).map(_tile).toList(),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a tile for each [tag] that can be selected or deselected.
  ///
  /// When tapped, the tile toggles the tag's selection state in the [widget.controller.selectedTagsState].
  /// The tile displays the tag's icon and name.
  /// 
  /// The tile also displays a visual indicator when the tag is selected.
  Widget _tile((TagEnumeration, String, int) record) {
    final TagEnumeration tag = record.$1;
    final String name = record.$2;
    final int count = record.$3;

    final ValueNotifier<bool> isSelected = ValueNotifier<bool>(widget.controller.selectedTagsState.value.contains(tag.code));

    return InkWell(
      borderRadius: kBorderRadius,
      onTap: () {
        final List<String> temporary = widget.controller.selectedTagsState.value;

        if (temporary.contains(tag.code)) {
          temporary.remove(tag.code);
          isSelected.value = !isSelected.value;
        }
        else if (temporary.length < 3) {
          temporary.add(tag.code);
          isSelected.value = !isSelected.value;
        }
        
        widget.controller.selectedTagsState.value = List.from(temporary);
      },
      child: ValueListenableBuilder(
        valueListenable: isSelected,
        builder: (BuildContext context, bool isSelected, Widget? _) {
          return FittedBox(
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: kBorderRadius,
                color: isSelected
                  ? ColorEnumeration.primary.value.withAlpha(190)
                  : ColorEnumeration.foreground.value,
              ),
              height: 30,
              padding: const EdgeInsets.fromLTRB(12.5, 0, 12.5, 0),
              child: Row(
                spacing: 7.5,
                children: <Widget> [
                  Icon(
                    tag.icon,
                    color: ColorEnumeration.grey.value,
                    size: 18,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "$name • $count",
                      style: TypographyEnumeration.body(ColorEnumeration.grey).style,
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