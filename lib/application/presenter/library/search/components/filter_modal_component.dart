part of '../search_handler.dart';

// FILTER MODAL 🧩: ============================================================================================================================================================= //

/// A widget that displays the filter options for searching.
///
/// This modal content provides two main filter categories: categories (tags) and publishers.
/// Users can refine their search by selecting or deselecting the respective filters.
class _FilterModal extends StatelessWidget {

  const _FilterModal({
    required this.applyFilters,
    required this.clearFilters,
    required this.publisherState,
    required this.tagsState,
  });

  final VoidCallback applyFilters;

  final VoidCallback clearFilters;

  /// The current state of the publisher filter.
  /// 
  /// This state is managed by the [Search] controller and holds the selected publisher.
  final ValueNotifier<String?> publisherState;

  /// The current state of the tags filter.
  /// 
  /// This state is managed by the [Search] controller and holds the selected tags.
  final ValueNotifier<List<String>> tagsState;

  @override
  Widget build(BuildContext context) {
    return ModalWidget(
      actions: <Widget> [
        const Spacer(),
        ButtonWidget.icon(
          icon: HugeIcons.strokeRoundedCancel01,
          onTap: context.pop,
        ),
        ButtonWidget.icon(
          icon: HugeIcons.strokeRoundedClean,
          onTap: () {
            clearFilters();
            context.pop();
          }
        ),
        ButtonWidget.icon(
          icon: HugeIcons.strokeRoundedTick01,
          onTap: () {
            applyFilters();
            context.pop();
          }
        ),
      ],
      child: ListView(
        children: <Widget> [
          Align(
            alignment: Alignment.centerLeft,
            child: Section(
              description: AppLocalizations.of(context)!.sectionCategoryFiltersDescription,
              title: AppLocalizations.of(context)!.sectionCategoryFilters,
              child: _Categories(
                tagsState: tagsState,
              ),
            ),
          ),
          Divider(
            color: ColorEnumeration.divider.value,
            thickness: 1,
            height: 1,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Section(
              description: AppLocalizations.of(context)!.sectionPublisherFiltersDescription,
              title: AppLocalizations.of(context)!.sectionPublisherFilters,
              child: _Publishers(
                publisherState: publisherState,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CATEGORIES FILTER 🧩: ======================================================================================================================================================== //

/// A widget that displays a list of category tags for filtering games.
///
/// This widget allows the user to select and deselect category tags to refine their search.
class _Categories extends StatelessWidget {

  const _Categories({
    required this.tagsState,
  });

  /// The current state of the tags filter.
  /// 
  /// This state is managed by the [Search] controller and holds the selected tags.
  final ValueNotifier<List<String>> tagsState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Wrap(
        runSpacing: 7.5,
        spacing: 7.5,
        children: TagEnumeration.values.map(_tile).toList(),
      ),
    );
  }

  /// Builds a tile for each [tag] that can be selected or deselected.
  ///
  /// When tapped, the tile toggles the tag's selection state in the [tagsState].
  Widget _tile(TagEnumeration tag) {
    final ValueNotifier<bool> isSelected = ValueNotifier<bool>(tagsState.value.contains(tag.code));
    return InkWell(
      borderRadius: kBorderRadius,
      onTap: () {

        // Toggle tag selection in the tagsState.
        if (tagsState.value.contains(tag.code)) {
          tagsState.value.remove(tag.code);
        }
        else {
          tagsState.value.add(tag.code);
        }
        isSelected.value = !isSelected.value;
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
                children: <Widget>[
                  Icon(
                    tag.icon,
                    color: ColorEnumeration.grey.value,
                    size: 18,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      tag.fromLocale(AppLocalizations.of(context)!),
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

// PUBLISHERS FILTERS 🧩: ======================================================================================================================================================= //

/// A widget that creates a grid of publisher filter tiles.
///
/// This widget displays a list of publisher options as tiles. Each tile can be tapped to toggle the selected publisher filter.
/// When a publisher is selected, the [publisherState] is updated to reflect the choice.
class _Publishers extends StatefulWidget {

  const _Publishers({
    required this.publisherState,
  });

  /// The current state of the publisher filter.
  /// 
  /// This state is managed by the [Search] controller and is used to track the selected publisher.
  /// When a tile is tapped, the state is updated to either reflect the selected publisher or clear the selection.
  final ValueNotifier<String?> publisherState;

  @override
  State<_Publishers> createState() => _PublishersState();
}

class _PublishersState extends State<_Publishers> {
  final List<String> publishers = <String> [
    'Digital Chocolate',
    'Electronic Arts, Inc.',
    'Gameloft SA',
    'Glu Mobile LLC',
    'I-play',
    'Konami Digital Entertainment, Inc.',
    'Micazook Ltd.',
    'Nano Games',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 7.5,
          crossAxisSpacing: 7.5,
          childAspectRatio: 1.25,
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: publishers.map(_tile).toList(),
      ),
    );
  }

  /// Builds a tile for each publisher with a toggle state.
  ///
  /// The tile displays the publisher's logo and changes color when selected.
  Widget _tile(String publisher) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {

        // Toggle the publisher selection on tap.
        widget.publisherState.value == publisher
          ? widget.publisherState.value = null
          : widget.publisherState.value = publisher;
      },
      child: ValueListenableBuilder(
        valueListenable: widget.publisherState,
        builder: (BuildContext context, String? isSelected, Widget? _) {
          return AspectRatio(
            aspectRatio: 1.25,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: isSelected == publisher
                  ? ColorEnumeration.primary.value.withAlpha(190)
                  : ColorEnumeration.foreground.value,
              ),
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: Image.asset(
                'assets/publishers/$publisher.png',
                filterQuality: FilterQuality.high,
              ),
            ),
          );
        },
      ),
    );
  }
}