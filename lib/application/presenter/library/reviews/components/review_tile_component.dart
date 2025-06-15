part of '../reviews_handler.dart';

class _ReviewTile extends StatelessWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  /// Contains the user's review data, such as rating, comment, and metadata.
  final Review review;

  const _ReviewTile({
    required this.controller,
    required this.localizations,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
      child: Column(
        spacing: 7.5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.horizontal,
            spacing: 7.5,
            runSpacing: 7.5,
            children: <Widget> [
              Text(
                "${review.flag} • ${review.userName.toUpperCase()}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TypographyEnumeration.headline(Palettes.elements).style,
              ),
              Text(
                review.fRelativeDate(review.locale),
                style: TypographyEnumeration.body(Palettes.grey).style,
              ),
            ],
          ),
          RatingStarsWidget(
            rating: review.rating.toDouble(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 7.5, 0, 0),
            child: Text(
              review.fBody(localizations),
              style: TypographyEnumeration.body(Palettes.elements).style,
            ),
          ),
          _Score(
            controller: controller,
            review: review,
          ),
        ],
      ),
    );
  }
}