part of '../reviews_handler.dart';

class _ReviewTile extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Contains the user's review data, such as rating, comment, and metadata.
  final Review review;

  const _ReviewTile({
    required this.controller,
    required this.review,
  });

  @override
  State<_ReviewTile> createState() => _ReviewTileState();
}

class _ReviewTileState extends State<_ReviewTile> {
  late final AppLocalizations l10n = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
      child: Column(
        spacing: 7.5,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Row(
            spacing: 7.5,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              Text(
                "${widget.review.flag} • ${widget.review.nickname.toUpperCase()}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TypographyEnumeration.headline(Palettes.elements).style,
              ),
              const Spacer(),
              Icon(
                HugeIcons.strokeRoundedArrowRight01,
                color: Palettes.elements.value,
                size: gIconSmall,
              ),
            ],
          ),
          Text(
            widget.review.fRelativeDate,
            style: TypographyEnumeration.body(Palettes.grey).style,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              Rating.star(widget.review.rating),
              Text(
                " / ",
                style: TypographyEnumeration.body(Palettes.grey).style,
              ),
              Rating.difficulty(widget.review.difficulty),
              Text(
                " / ",
                style: TypographyEnumeration.body(Palettes.grey).style,
              ),
              Rating.playthroughTime(widget.review.playthroughTime),
            ],
          ),
          Text(
            widget.review.fBody(l10n),
            style: TypographyEnumeration.body(Palettes.elements).style,
          ),
          // _Score(controller: widget.controller, review: widget.review),
        ],
      ),
    );
  }
}