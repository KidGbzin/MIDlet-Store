part of '../search_handler.dart';

/// A modal widget that displays a list of years to filter by.
///
/// This widget is composed of a list of tiles, each representing a year.
/// The selected year is then used to filter the list of games.
class _ReleaseModal extends StatefulWidget {

  const _ReleaseModal({
    required this.controller,
  });

  /// The controller that manages the state of the game list.
  /// 
  /// This controller is responsible for managing the state of the search bar and the filters.
  final _Controller controller;

  @override
  State<_ReleaseModal> createState() => _ReleaseModalState();
}

class _ReleaseModalState extends State<_ReleaseModal> {
  late final int? _initialState;

  @override
  void initState() {
    _initialState = widget.controller.selectedReleaseYearState.value;

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
            widget.controller.selectedReleaseYearState.value = _initialState;
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
      child: Section(
        description: AppLocalizations.of(context)!.sectionFilterReleaseYearDescription,
        title: AppLocalizations.of(context)!.sectionFilterReleaseYear,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Wrap(
            runSpacing: 7.5,
            spacing: 7.5,
            children: widget.controller.getReleaseYears().map(_tile).toList(),
          ),
        ),
      ),
    );
  }

  Widget _tile(int releaseYear) {
    return InkWell(
      borderRadius: kBorderRadius,
      onTap: () {

        // Toggle the year selection on tap.
        widget.controller.selectedReleaseYearState.value == releaseYear
          ? widget.controller.selectedReleaseYearState.value = null
          : widget.controller.selectedReleaseYearState.value = releaseYear;
      },
      child: ValueListenableBuilder(
        valueListenable: widget.controller.selectedReleaseYearState,
        builder: (BuildContext context, int? selectedReleaseYear, Widget? _) {
          return FittedBox(
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: kBorderRadius,
                color: selectedReleaseYear == releaseYear
                  ? ColorEnumeration.primary.value.withAlpha(190)
                  : ColorEnumeration.foreground.value,
              ),
              height: 30,
              padding: const EdgeInsets.fromLTRB(12.5, 0, 12.5, 0),
              child: Row(
                spacing: 7.5,
                children: <Widget> [
                  Icon(
                    HugeIcons.strokeRoundedCalendar01,
                    color: ColorEnumeration.grey.value,
                    size: 18,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      releaseYear.toString(),
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