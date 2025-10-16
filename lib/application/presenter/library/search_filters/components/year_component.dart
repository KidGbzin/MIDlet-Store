part of '../search_filters_handler.dart';

class _Year extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller cHandler;

  const _Year(this.cHandler);

  @override
  State<_Year> createState() => _YearState();
}

class _YearState extends State<_Year> {
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
                HugeIcons.strokeRoundedCalendar01,
                color: Palettes.elements.value,
                size: gIconSmall,
              ),
              Expanded(
                child: Text(
                  l10n.sectionFilterReleaseYear,
                  style: TypographyEnumeration.headline(Palettes.elements).style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            l10n.sectionFilterReleaseYearDescription,
            style: TypographyEnumeration.body(Palettes.elements).style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          ValueListenableBuilder(
            valueListenable: widget.cHandler.nActiveYear,
            builder: (BuildContext context, int? activeYear, Widget? _) {
              return GridView(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 7.5,
                  crossAxisSpacing: 7.5,
                  childAspectRatio: 1.25,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: widget.cHandler.filters.years.map((record) {
                  return tile(
                    count: record.count,
                    isActive: activeYear == record.year,
                    year: record.year,
                  );
                }).toList(),
              );
            }
          ),
        ],
      ),
    );
  }

  Widget tile({
    required int count,
    required bool isActive,
    required int year,
  }) {  
    return InkWell(
      borderRadius: gBorderRadius,
      onTap: () => widget.cHandler.onYearChange(year),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: gBorderRadius,
          color: isActive
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
                "$year",
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
                  size: gIconSmall,
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
      ),
    );
  }
}
