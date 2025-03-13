part of '../search_handler.dart';

// RELEASE MODAL 📅: ============================================================================================================================================================ //

/// A modal widget that displays a list of years to filter by.
///
/// This widget is composed of a list of tiles, each representing a year.
/// The selected year is then used to filter the list of games.
class _ReleaseModal extends StatefulWidget {

  const _ReleaseModal(this.controller);

  /// The controller that manages the state of the game list.
  /// 
  /// This controller is responsible for managing the state of the search bar and the filters.
  final _Controller controller;

  @override
  State<_ReleaseModal> createState() => _ReleaseModalState();
}

class _ReleaseModalState extends State<_ReleaseModal> {
  late final int? _initialState;
  late final AppLocalizations localizations;

  @override
  void initState() {
    _initialState = widget.controller.selectedReleaseYearState.value;

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
            widget.controller.selectedReleaseYearState.value = _initialState;
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
      child: SingleChildScrollView(
        child: Section(
          description: localizations.sectionFilterReleaseYearDescription,
          title: localizations.sectionFilterReleaseYear,
          child: Padding(
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
              children: widget.controller.getReleaseYears().entries.map(_tile).toList(),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a tile for each year that can be selected or deselected.
  ///
  /// The tile displays the year and the number of games released in that year.
  /// When tapped, the tile toggles the year's selection state in the [widget.controller.selectedReleaseYearState].
  /// The tile also displays a visual indicator when the year is selected.
  Widget _tile(MapEntry<int, int> entry) {
    final int releaseYear = entry.key;
    final int count = entry.value;
  
    return InkWell(
      borderRadius: gBorderRadius,
      onTap: () {

        // Toggle the year selection on tap.
        widget.controller.selectedReleaseYearState.value == releaseYear
          ? widget.controller.selectedReleaseYearState.value = null
          : widget.controller.selectedReleaseYearState.value = releaseYear;
      },
      child: ValueListenableBuilder(
        valueListenable: widget.controller.selectedReleaseYearState,
        builder: (BuildContext context, int? selectedReleaseYear, Widget? _) {
          return Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
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