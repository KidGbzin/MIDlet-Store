part of '../search_filters_handler.dart';

class _Publisher extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller cHandler;

  const _Publisher(this.cHandler);

  @override
  State<_Publisher> createState() => _PublisherState();
}

class _PublisherState extends State<_Publisher> {
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
                HugeIcons.strokeRoundedCorporate,
                color: Palettes.elements.value,
                size: gIconSmall,
              ),
              Expanded(
                child: Text(
                  l10n.sectionFilterPublisher,
                  style: TypographyEnumeration.headline(Palettes.elements).style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            l10n.sectionFilterPublisherDescription,
            style: TypographyEnumeration.body(Palettes.elements).style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          ValueListenableBuilder(
            valueListenable: widget.cHandler.nActivePublisher,
            builder: (BuildContext context, String? publisher, Widget? _) {
              return Wrap(
                spacing: 7.5,
                runSpacing: 7.5,
                children: widget.cHandler.filters.publishers.map((record) {
                  return tile(
                    count: record.count,
                    isActive: publisher == record.publisher,
                    publisher: record.publisher,
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
    required bool isActive,
    required String publisher,
    required int count,
  }) {
    return InkWell(
      borderRadius: gBorderRadius,
      onTap: () => widget.cHandler.onPublisherChange(publisher),
      child: FittedBox(
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: gBorderRadius,
            color: isActive
              ? Palettes.primary.value.withAlpha(190)
              : Palettes.foreground.value,
          ),
          height: 30,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "$publisher • $count",
                style: TypographyEnumeration.body(Palettes.grey).style,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
